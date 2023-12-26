import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:base_flutter_bloc/api/url_config.dart';
import 'package:base_flutter_bloc/common/logger/logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
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

class DioClient {
  PackageInfo? packageInfo;
  int? appBuildVersion;
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;
  String? deviceUuid;
  Dio? _dio;
  bool _isRefreshingToken = false;
  final Map<ErrorInterceptorHandler, RequestOptions> _mappingQueueRequest = {};

  Future<void> _doExpire() async {
    log('Actual expire, return login screen');
    SharedPreferenceUtil.setTokenInfo(null);
  }

  Future<TokenInfo?> refreshFuture(String? refreshToken) async {
    if (refreshToken != null) {
      var response = await _dio!.post(
        UrlConfig.refreshToken,
        data: {"refreshToken": refreshToken},
      );
      LogUtils.i(response.data["token"]);
      TokenInfo tokenInfo = TokenInfo(
          accessToken: response.data["token"],
          refreshToken: response.data["refreshToken"]);
      return tokenInfo;
    }
    return null;
  }

  Future<void> _issueNewToken(TokenInfo currentTokenInfo) async {
    try {
      _isRefreshingToken = true;
      final newTokenInfo = await refreshFuture(currentTokenInfo.refreshToken);
      LogUtils.d('New Token Info: ${newTokenInfo?.toJson()}');
      await SharedPreferenceUtil.setTokenInfo(newTokenInfo);
    } finally {
      _isRefreshingToken = false;
    }
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
        _mappingQueueRequest.clear();
        handler.next(error);
      } else if (error.response?.statusCode == 401) {
        final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
        LogUtils.e("Case 401 tokenInfoStr: \n${jsonEncode(tokenInfo) ?? ""}");
        if (tokenInfo == null) {
          handler.next(error);
        } else {
          try {
            ///add current request to queue
            _addRequestToQueue(handler, error.requestOptions);
            if (!_isRefreshingToken) {
              {
                await _issueNewToken(tokenInfo);
                await _repeatResponse();
                _mappingQueueRequest.clear();
              }
            }
          } catch (err) {
            LogUtils.e('Get newTokenInfo catch: \n$err');
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
    if (response.requestOptions.path == UrlConfig.login &&
        response.data["status"] == "Logged in") {
      SharedPreferenceUtil.setTokenInfo(
        TokenInfo(
          accessToken: response.data["token"],
          refreshToken: response.data["refreshToken"],
        ),
      );
    }
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

    var header = await _getDefaultHeader();
    request.headers = header;
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
      if (tokenInfo.accessToken?.isNotEmpty == true) {
        return {
          "Content-type": "application/json",
          "Authorization": "Bearer ${tokenInfo.accessToken}"
        };
      }
      throw ("token not found");
    } catch (err) {
      return {
        "Content-type": "application/json",
      };
    }
  }

  InterceptorsWrapper _getDefaultInterceptor(Dio dio,
      {required bool shouldHandleException}) {
    return InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) =>
          _onErrorInterceptor(error, handler, dio, shouldHandleException),
      onResponse: _onResponseInterceptor,
      onRequest: _onRequestInterceptor,
    );
  }

  Dio getDefaultInstance() {
    String apiUrl = dotenv.get("api_server_url");
    _dio ??= Dio();
    _dio!.options.connectTimeout = const Duration(seconds: _connectTimeout);
    _dio!.options.receiveTimeout = const Duration(seconds: _receiveTimeout);
    _dio!.options.baseUrl = apiUrl;
    _dio!.interceptors.add(_getDefaultInterceptor(
      _dio!,
      shouldHandleException: true,
    ));
    return _dio!;
  }

  Future<void> _addRequestToQueue(
      ErrorInterceptorHandler handler, RequestOptions requestOptions) async {
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
    _mappingQueueRequest[handler] = requestOptions;
  }

  Future _repeatResponse() {
    return Future.wait(_mappingQueueRequest.entries
        .toList()
        .map((e) => _handleRepeatResponse(e))
        .toList());
  }

  Future<void> _handleRepeatResponse(
      MapEntry<ErrorInterceptorHandler, RequestOptions> data) async {
    final repeatedResponse = await _dio!.fetch(data.value);
    return data.key.resolve(repeatedResponse);
  }
}
