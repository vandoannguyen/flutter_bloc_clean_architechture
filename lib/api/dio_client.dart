import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http_parser/http_parser.dart';
import 'package:base_flutter_bloc/api/url_config.dart';
import 'package:base_flutter_bloc/common/logger/logger.dart';
import 'package:base_flutter_bloc/model/entity/index.dart';
import 'package:mime/mime.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../exception/business_exception.dart';
import '../../exception/network_exception.dart';
import '../../exception/server_exception.dart';
import '../model/entity/error/business_error.dart';
import '../routes/index.dart';
import '../utils/alice_utils.dart';
import '../utils/navigate_utils.dart';
import '../utils/share_preference_utils.dart';

const int _connectTimeout = 30000;
const int _receiveTimeout = 30000;

class DioClient {
  PackageInfo? packageInfo;
  int? appBuildVersion;
  String? deviceUuid;
  Dio? _dio;
  bool _isRefreshingToken = false;
  final Map<ErrorInterceptorHandler, RequestOptions> _mappingQueueRequest = {};

  Future<void> _doExpire() async {
    SharedPreferenceUtil.setTokenInfo(null);
    NavigatorUtils.instance.pushNamedAndRemoveUntil(
      AppRoutes.login.routeName,
      (predicate) => false,
    );
  }

  Future<TokenInfo?> refreshFuture(String? refreshToken) async {
    if (refreshToken != null) {
      var header = await _getDefaultHeader();
      header["Authorization"] = "Bearer $refreshToken";
      String apiUrl = dotenv.get("api_server_url");
      var response = await _createDioClient().fetch(
        RequestOptions(
          path: "$apiUrl${UrlConfig.refreshToken}",
          headers: header,
          method: "POST",
        ),
      );
      TokenInfo tokenInfo = TokenInfo.fromJson(response.data);
      return tokenInfo;
    }
    return null;
  }

  Future<void> _issueNewToken(TokenInfo currentTokenInfo) async {
    try {
      _isRefreshingToken = true;
      final newTokenInfo = await refreshFuture(currentTokenInfo.refreshToken);
      if (newTokenInfo != null) {
        SharedPreferenceUtil.setTokenInfo(newTokenInfo);
      } else {
        await _doExpire();
        _mappingQueueRequest.clear();
      }
    } catch (err) {
      await _doExpire();
      _mappingQueueRequest.clear();
      LogUtils.e("_issueNewToken$err");
      rethrow;
    } finally {
      _isRefreshingToken = false;
    }
  }

  void _onErrorInterceptor(
    DioException error,
    ErrorInterceptorHandler handler,
    Dio dio,
  ) async {
    LogUtils.e(
      "Error interceptor: "
      "\nBase url: ${error.requestOptions.baseUrl} "
      "\n-> Path: ${error.requestOptions.path} "
      "\n-> Request Header: ${error.requestOptions.headers} "
      "\n-> Query params: ${error.requestOptions.queryParameters} "
      "\n-> Request Data: ${error.requestOptions.data}"
      "\n-> Error Data: ${error.response?.data.toString() ?? ""} "
      "\n-> Error Status Code: ${error.response?.statusCode.toString() ?? ""}",
    );

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.unknown) {
      handler.next(
        NetworkException(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
        ),
      );
      return;
    }
    if (error.type == DioExceptionType.badResponse) {
      final statusCode = error.response?.statusCode ?? 0;

      if (error.requestOptions.path == UrlConfig.refreshToken &&
          statusCode == 400) {
        await _doExpire();
        _mappingQueueRequest.clear();
        return;
      }
      if (statusCode == 401) {
        final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
        if (tokenInfo?.refreshToken == null) {
          handler.next(error);
          return;
        }

        try {
          await _addRequestToQueue(handler, error.requestOptions);

          if (!_isRefreshingToken) {
            await _issueNewToken(tokenInfo!);
            await _repeatResponse();
            _mappingQueueRequest.clear();
          }
        } catch (err) {
          LogUtils.e("Refresh token failed: $err");
          handler.next(err is DioException ? err : error);
        }
        return;
      }
      if (statusCode <= 500) {
        handler.next(
          BusinessException(
            businessError: BusinessError.fromJson(error.response!.data),
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
          ),
        );
        return;
      }
      // if (statusCode == 502) {
      //   _handleShowMaintenance();
      //   return;
      // }
      handler.next(
        ServerException(
          businessError: BusinessError.fromJson({}),
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
        ),
      );
      return;
    }
    handler.next(error);
  }

  Future<void> _onResponseInterceptor(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    LogUtils.d(
      "Response: \n${response.requestOptions.method} :"
      "\n${response.requestOptions.baseUrl}${response.requestOptions.path} "
      "\n--> ${response.requestOptions.data}",
    );
    LogUtils.i(
      "Response interceptor: Base Url: ${response.requestOptions.baseUrl} "
      "\n-> Response Data: ${response.data}",
    );
    if ((response.requestOptions.path == UrlConfig.login &&
            response.statusCode == 201) ||
        response.requestOptions.path == UrlConfig.refreshToken) {
      SharedPreferenceUtil.setTokenInfo(
        TokenInfo(
          accessToken: response.data["accessToken"],
          refreshToken: response.data["refreshToken"],
        ),
      );
    }
    handler.next(response);
  }

  void _onRequestInterceptor(
    RequestOptions request,
    RequestInterceptorHandler handler,
  ) async {
    if (packageInfo == null) {
      PackageInfo data = await PackageInfo.fromPlatform();
      packageInfo = data;
    }
    String? authorization;
    if (request.path == UrlConfig.refreshToken) {
      authorization = request.headers["Authorization"];
    }
    var header = await _getDefaultHeader(exitsToken: authorization);
    request.headers = header;
    request.data = await _formData(request);
    LogUtils.i(_generateCurlCommand(request));
    handler.next(request);
  }

  String _generateCurlCommand(RequestOptions options) {
    final buffer = StringBuffer();

    buffer.write("curl -X ${options.method} \"${options.uri}\"");

    // Thêm headers
    options.headers.forEach((key, value) {
      buffer.write(" -H \"$key: $value\"");
    });

    // Thêm data body nếu có
    if (options.data != null) {
      if (options.data is FormData) {
        final formData = options.data as FormData;
        for (var field in formData.fields) {
          buffer.write(" -F \"${field.key}=${field.value}\"");
        }

        for (var file in formData.files) {
          final fileField = file.key;
          final MultipartFile multipartFile = file.value;
          final filePath = multipartFile.filename ?? 'file';

          buffer.write(" -F \"$fileField=@$filePath\"");
        }
      } else if (options.data is Map) {
        final dataString = jsonEncode(options.data);
        buffer.write(" -d '$dataString'");
      } else if (options.data is String) {
        buffer.write(" -d '${options.data}'");
      }
    }

    return buffer.toString();
  }

  Future<Map<String, dynamic>> _getDefaultHeader({String? exitsToken}) async {
    try {
      final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
      if (tokenInfo == null) {
        return {"Content-type": "application/json"};
      }
      if (tokenInfo.accessToken?.isNotEmpty == true) {
        return {
          "Content-type": "application/json",
          "Authorization": exitsToken ?? "Bearer ${tokenInfo.accessToken}",
        };
      }
      throw ("token not found");
    } catch (err) {
      return {"Content-type": "application/json"};
    }
  }

  InterceptorsWrapper _getDefaultInterceptor(Dio dio) {
    return InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) =>
          _onErrorInterceptor(error, handler, dio),
      onResponse: _onResponseInterceptor,
      onRequest: _onRequestInterceptor,
    );
  }

  Dio getDefaultInstance() {
    final Dio dio = _createDioClient();
    dio.interceptors.add(_getDefaultInterceptor(dio));
    _dio ??= dio;
    return _dio!;
  }

  Dio _createDioClient() {
    String apiUrl = dotenv.get("api_server_url");
    Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: _connectTimeout);
    dio.options.receiveTimeout = const Duration(seconds: _receiveTimeout);
    dio.options.baseUrl = apiUrl;
    const flavor = String.fromEnvironment('FLUTTER_APP_FLAVOR');
    if (flavor == "dev" || flavor == "uat") {
      dio.interceptors.add(AliceUtils.instance.aliceDioAdapter!);
    }
    return dio;
  }

  Future<void> _addRequestToQueue(
    ErrorInterceptorHandler handler,
    RequestOptions requestOptions,
  ) async {
    try {
      requestOptions.headers = await _getDefaultHeader();
      requestOptions.data = await _formData(requestOptions);
      _mappingQueueRequest[handler] = requestOptions;
    } catch (err) {
      LogUtils.e("err");
    }
  }

  dynamic _formData(RequestOptions requestOptions) async {
    if (requestOptions.data is FormData) {
      FormData formData = FormData();
      formData.fields.addAll(requestOptions.data.fields);
      for (MapEntry mapFile in requestOptions.data.files) {
        final file = mapFile.value as MultipartFile;
        final mimeType =
            lookupMimeType(file.filename ?? "") ?? 'application/octet-stream';
        final mediaType = MediaType.parse(mimeType);
        final stream = file.finalize();
        final chunks = await stream.toList(); // List<List<int>>
        final bytes = chunks.expand((chunk) => chunk).toList();
        formData.files.add(
          MapEntry(
            mapFile.key,
            MultipartFile.fromBytes(
              bytes,
              filename: file.filename ?? "",
              contentType: mediaType,
            ),
          ),
        );
      }
      return formData;
    }
    return requestOptions.data;
  }

  Future _repeatResponse() {
    return Future.wait(
      _mappingQueueRequest.entries
          .toList()
          .map((e) => _handleRepeatResponse(e))
          .toList(),
    );
  }

  Future<void> _handleRepeatResponse(
    MapEntry<ErrorInterceptorHandler, RequestOptions> data,
  ) async {
    final header = data.value.headers;
    final tokenInfo = await SharedPreferenceUtil.getTokenInfo();
    header["Authorization"] = "Bearer ${tokenInfo!.accessToken}";
    final repeatedResponse = await _dio!.fetch(data.value);
    return data.key.resolve(repeatedResponse);
  }

  // void _handleShowMaintenance() {
  //   MaintenancePage.show();
  // }
}
