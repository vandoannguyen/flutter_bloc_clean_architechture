import 'dart:developer';

import 'package:baese_flutter_bloc/common/utils/function.dart';
import 'package:baese_flutter_bloc/module/domain/usecase/auth_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';

import '../../../module/domain/entity/token_info.dart';
import '../../share_preference_util.dart';
import '../navigate_utils.dart';
import 'exception/business_error.dart';
import 'exception/business_exception.dart';
import 'exception/network_exception.dart';
import 'exception/server_exception.dart';
import 'multipart_file_extended.dart';

const Duration CONNECT_TIMEOUT = Duration(milliseconds: 30000);
const Duration RECEIVE_TIMEOUT = Duration(milliseconds: 30000);
Future<TokenInfo?>? refreshFuture;

@injectable
class DioClient {
  int? appBuildVersion;
  late AuthUseCase authUseCase;

  @singleton
  DioClient(this.authUseCase);

  Future<void> _doExpire() async {
    log('Actual expire, return login screen');
    refreshFuture = null;
    FunctionUtils.instance.logoutLocal();
  }

  Future<void> _issueNewToken(TokenInfo currentTokenInfo) async {
    refreshFuture ??= authUseCase.refreshToken(currentTokenInfo.refreshToken);
    final newTokenInfo = await refreshFuture;
    log('New Token Info: ${newTokenInfo!.toJson()}');
    await SharedPreferenceUtil.setTokenInfo(newTokenInfo);
    refreshFuture = null;
  }

  void _onErrorInterceptor(
    DioError error,
    ErrorInterceptorHandler handler,
    Dio dio,
    bool shouldHandleException,
  ) async {
    log("Error interceptor: Base url: ${error.requestOptions.baseUrl} -> Path: ${error.requestOptions.path} -> Request Header: ${error.requestOptions.headers} -> Query paramms: ${error.requestOptions.queryParameters} -> Request Data: ${error.requestOptions.data} -> Error Data: ${error.response?.data.toString() ?? ""} -> Error Status Code: : ${error.response?.statusCode.toString() ?? ""}");
    if (error.type == DioErrorType.connectionTimeout ||
        error.type == DioErrorType.receiveTimeout ||
        error.type == DioErrorType.sendTimeout) {
      log('Request Timeout: ${error.requestOptions.path}');
      if (shouldHandleException) {
        NavigateUtils.instance.showNoInternetErrorDialog();
      } else {
        handler.next(
          NetworkException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
          ),
        );
        return;
      }
    } else if (error.type == DioErrorType.unknown) {
      log('Other Network Issue: ${error.requestOptions.path}');
      if (shouldHandleException) {
        NavigateUtils.instance.showNoInternetErrorDialog();
      } else {
        handler.next(
          NetworkException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
          ),
        );
        return;
      }
    }
    if (error.type == DioErrorType.badResponse) {
      if (error.requestOptions.path == '/authentication/refresh-token' &&
          error.response?.statusCode == 400) {
        await _doExpire();
        handler.next(error);
      } else if (error.response?.statusCode == 401) {
        final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
        log("Case 401 tokenInfoStr: ${tokenInfo?.toString() ?? ""}");
        if (tokenInfo == null) {
          handler.next(error);
        } else {
          try {
            await _issueNewToken(tokenInfo);
            // Repeat the request
            RequestOptions requestOptions = error.requestOptions;
            requestOptions.headers = await _getDefaultHeader();
            if (requestOptions.data is FormData) {
              FormData formData = FormData();
              formData.fields.addAll(requestOptions.data.fields);
              for (MapEntry mapFile in requestOptions.data.files) {
                formData.files.add(
                  MapEntry(
                    mapFile.key,
                    MultipartFileExtended.fromFileSync(
                      mapFile.value.filePath,
                      filename: mapFile.value.filename,
                    ),
                  ),
                );
              }
              requestOptions.data = formData;
            }
            final repeatedResponse = await dio.fetch(requestOptions);
            handler.resolve(repeatedResponse);
          } catch (err) {
            log('Get newTokenInfo catch: $err');
            refreshFuture = null;
            if (err is DioError &&
                err.requestOptions.path == '/authentication/refresh-token' &&
                (err.response?.statusCode == 400)) {
              _doExpire();
            }
            handler.next(err is DioError ? err : error);
          }
        }
      } else {
        log("Response error intercept: ${error.response!.data} --> ${error.requestOptions.path}");
        if (error.response == null) {
          handler.next(error);
        } else if (error.response!.statusCode! > 401) {
          if (shouldHandleException) {
            NavigateUtils.instance.showGeneralErrorDialog();
          } else {
            handler.next(
              ServerException(
                businessError: BusinessError.fromJson(error.response!.data),
                requestOptions: error.requestOptions,
                response: error.response,
                type: error.type,
              ),
            );
            return;
          }
        } else {
          log('Case business exception');
          /*
            Xử lý chung phục vụ trong trường hợp
            User bị xóa nhưng vẫn muốn hiển thị trong màn userpage
            Hiển thị dialog [showUserDeletedDialog]
          */
          if (error.response != null) {
            if (error.response!.data["error_data"] is String &&
                error.response!.data["error_code"] == "user-was-deleted") {
              NavigateUtils.instance.showUserDeletedDialog(
                  error.response!.data["error_data"].toString());
            }
          }

          handler.next(
            BusinessException(
              businessError: BusinessError.fromJson(error.response!.data),
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
            ),
          );
        }
      }
    } else {
      handler.next(error);
    }
  }

  void _onResponseInterceptor(
      Response response, ResponseInterceptorHandler handler) {
    log("Response: ${response.requestOptions.method} : ${response.requestOptions.baseUrl}${response.requestOptions.path} --> ${response.requestOptions.data}");
    log("Response interceptor: Base Url: ${response.requestOptions.baseUrl} -> Path: ${response.requestOptions.path} -> Request Header: ${response.requestOptions.headers} -> Query Params: ${response.requestOptions.queryParameters} -> Request Data: ${response.requestOptions.data} -> Status Code: ${response.statusCode} -> Response Data: ${response.data}");
    handler.next(response);
  }

  void _onRequestInterceptor(
      RequestOptions request, RequestInterceptorHandler handler) async {
    log(
      "${request.method} : ${request.baseUrl}${request.path} --> ${request.queryParameters} --> ${request.data}",
    );
    final apiVersion = dotenv.env["API_VERSION"];
    appBuildVersion ??= int.tryParse(dotenv.env["APP_BUILD_VERSION"]!);
    if (appBuildVersion != null) {
      request.headers["APP_VERSION_CODE"] = appBuildVersion;
    }
    request.headers["X-API-VERSION"] = apiVersion;
    handler.next(request);
  }

  Future<Map<String, dynamic>> _getDefaultHeader() async {
    try {
      final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
      if (tokenInfo == null) {
        return {
          "Content-type": "application/json",
        };
      }
      return {
        "Content-type": "application/json",
        "Authorization": "Bearer ${tokenInfo.accessToken!}"
      };
    } catch (err) {
      return {
        "Content-type": "application/json",
      };
    }
  }

  InterceptorsWrapper getDefaultInterceptor(Dio dio,
      {required bool shouldHandleException}) {
    return InterceptorsWrapper(
      onError: (DioError error, ErrorInterceptorHandler handler) =>
          _onErrorInterceptor(error, handler, dio, shouldHandleException),
      onResponse: _onResponseInterceptor,
      onRequest: _onRequestInterceptor,
    );
  }

  Future<Dio> getDefaultInstance({
    bool useDefaultHeader = true,
    bool useDefaultInterceptor = true,
    bool shouldHandleException = true,
  }) async {
    String? apiUrl = dotenv.env["API_SERVER_URL"];
    Dio dio = Dio();
    dio.options.connectTimeout = CONNECT_TIMEOUT;
    dio.options.receiveTimeout = RECEIVE_TIMEOUT;
    dio.options.baseUrl = apiUrl!;
    if (useDefaultHeader) {
      dio.options.headers = await _getDefaultHeader();
    }
    if (useDefaultInterceptor) {
      dio.interceptors.add(getDefaultInterceptor(
        dio,
        shouldHandleException: shouldHandleException,
      ));
    }
    return dio;
  }
}
