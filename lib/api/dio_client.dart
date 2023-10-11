import 'dart:developer';
import 'dart:io';

import 'package:baese_flutter_bloc/api/url_config.dart';
import 'package:baese_flutter_bloc/common/logger/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../exception/BusinessException.dart';
import '../../exception/NetworkException.dart';
import '../../exception/ServerException.dart';
import '../model/entity/error/business_error.dart';
import '../model/entity/token/token_info.dart';
import '../utils/navigate_utils.dart';
import '../utils/share_preference_utils.dart';
import 'multipart_file_extended.dart';

const int _connectTimeout = 30000;
const int _receiveTimeout = 30000;
Future<TokenInfo>? refreshFuture;

class DioClient {
  PackageInfo? packageInfo;
  int? appBuildVersion;
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;
  String? deviceUuid;

  Future<void> _doExpire() async {
    log('Actual expire, return login screen');
    refreshFuture = null;
  }

  Future<void> _issueNewToken(TokenInfo currentTokenInfo) async {
    ///todo
    ///refresh token
    // refreshFuture ??= AuthClient.refreshToken(currentTokenInfo.refreshToken);
    final newTokenInfo = await refreshFuture;
    LogUtils.d('New Token Info: ${newTokenInfo!.toJson()}');
    await SharedPreferenceUtil.setTokenInfo(newTokenInfo);
    refreshFuture = null;
  }

  void _onErrorInterceptor(
    DioException error,
    ErrorInterceptorHandler handler,
    Dio dio,
    bool shouldHandleException,
  ) async {
    LogUtils.e("Error interceptor: "
        "\nBase url: ${error.requestOptions.baseUrl} "
        "\n-> Path: ${error.requestOptions.path} "
        "\n-> Request Header: ${error.requestOptions.headers} "
        "\n-> Query paramms: ${error.requestOptions.queryParameters} "
        "\n-> Request Data: ${error.requestOptions.data}"
        "\n-> Error Data: ${error.response?.data.toString() ?? ""} "
        "\n-> Error Status Code: : ${error.response?.statusCode.toString() ?? ""}");
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      LogUtils.d('Request Timeout: ${error.requestOptions.path}');
      if (shouldHandleException) {
        NavigatorUtils.showNoInternetErrorDialog();
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
    } else if (error.type == DioExceptionType.unknown) {
      LogUtils.e('Other Network Issue: ${error.requestOptions.path}');
      if (shouldHandleException) {
        NavigatorUtils.showNoInternetErrorDialog();
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
    if (error.type == DioExceptionType.badResponse) {
      if (error.requestOptions.path == UrlConfig.refreshToken &&
          error.response?.statusCode == 400) {
        await _doExpire();
        handler.next(error);
      } else if (error.response?.statusCode == 401) {
        final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
        LogUtils.e("Case 401 tokenInfoStr: \n${tokenInfo?.toString() ?? ""}");
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
            LogUtils.e('Get newTokenInfo catch: \n$err');
            refreshFuture = null;
            if (err is DioException &&
                err.requestOptions.path == UrlConfig.refreshToken &&
                (err.response?.statusCode == 400)) {
              _doExpire();
            }
            handler.next(err is DioException ? err : error);
          }
        }
      } else {
        LogUtils.e("Response err intercept: "
            "\n${error.response!.data}"
            "\n--> ${error.requestOptions.path}");
        if (error.response == null) {
          handler.next(error);
        } else if (error.response!.statusCode! > 401) {
          if (shouldHandleException) {
            NavigatorUtils.showGeneralErrorDialog();
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
          LogUtils.e('Case business exception');
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
    LogUtils.d(
      "Response: \n${response.requestOptions.method} :"
      "\n${response.requestOptions.baseUrl}${response.requestOptions.path} "
      "\n--> ${response.requestOptions.data}",
    );
    LogUtils.i(
      "Response interceptor: Base Url: ${response.requestOptions.baseUrl} "
      "\n-> Path: ${response.requestOptions.path} "
      "\n-> Request Header: ${response.requestOptions.headers} "
      "\n-> Query Params: ${response.requestOptions.queryParameters} "
      "\n-> Request Data: ${response.requestOptions.data} "
      "\n-> Status Code: ${response.statusCode} "
      "\n-> Response Data: ${response.data}",
    );
    handler.next(response);
  }

  void _onRequestInterceptor(
      RequestOptions request, RequestInterceptorHandler handler) async {
    LogUtils.i(
      "[${request.method}] : "
      "\n${request.baseUrl}${request.path} "
      "\n--> ${request.queryParameters} "
      "\n--> ${request.data}",
    );
    if (packageInfo == null) {
      PackageInfo data = await PackageInfo.fromPlatform();
      packageInfo = data;
    }

    appBuildVersion ??= int.tryParse(dotenv.get("appBuildVersion"));

    if (packageInfo != null) {
      request.headers["APP_VERSION"] = packageInfo!.version;
    }

    if (appBuildVersion != null) {
      request.headers["APP_VERSION_CODE"] = appBuildVersion;
    }
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
        "Authorization": "Bearer ${tokenInfo.accessToken}"
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
      onError: (DioException error, ErrorInterceptorHandler handler) =>
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
    String apiUrl = dotenv.get("api_server_url");
    Dio dio = Dio();
    dio.options.connectTimeout = _connectTimeout as Duration?;
    dio.options.receiveTimeout = _receiveTimeout as Duration?;
    dio.options.baseUrl = apiUrl;
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
