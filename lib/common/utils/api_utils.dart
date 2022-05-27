import 'dart:async';
import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:dio/src/options.dart' as DioRequestOptions;

class ApiUtils {
  ListQueue<ApiRequestModel> apiQueryQueue = ListQueue();
  late Dio dio;
  String authToken = "";
  String refreshToken = "";
  final BaseOptions dioOptions = BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  static final ApiUtils instance = ApiUtils._getInstance();

  bool isRequestingRefreshToken = false;
  bool isQueryingFirst = false;

  ApiUtils._getInstance() {
    dio = Dio(dioOptions);
  }

  void setBaseUrl(String url) {
    dio.options.baseUrl = url;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    ApiUtilsOptions? options,
  }) {
    ApiUtilsOptions optionsRequest;
    if (options != null) {
      optionsRequest = options;
    } else {
      optionsRequest = _getBaseOptions();
    }
    optionsRequest.method = "get";
    Completer<Response> completer = Completer();
    _doQueue(
        apiRequestModel: ApiRequestModel(
      completer: completer,
      path: path,
      options: optionsRequest,
      queryParameters: queryParameters,
    ));
    return completer.future;
  }

  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    ApiUtilsOptions? options,
  }) {
    ApiUtilsOptions optionsRequest;
    if (options != null) {
      optionsRequest = options;
    } else {
      optionsRequest = _getBaseOptions();
    }
    optionsRequest.method = "post";
    Completer<Response> completer = Completer();
    _doQueue(
      apiRequestModel: ApiRequestModel(
        completer: completer,
        path: path,
        options: optionsRequest,
        data: data,
        queryParameters: queryParameters,
      ),
    );
    return completer.future;
  }

  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    ApiUtilsOptions? options,
  }) {
    ApiUtilsOptions optionsRequest;
    if (options != null) {
      optionsRequest = options;
    } else {
      optionsRequest = _getBaseOptions();
    }
    optionsRequest.method = "put";
    Completer<Response> completer = Completer();
    _doQueue(
        apiRequestModel: ApiRequestModel(
      completer: completer,
      path: path,
      options: optionsRequest,
      data: data,
      queryParameters: queryParameters,
    ));
    return completer.future;
  }

  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    ApiUtilsOptions? options,
  }) {
    ApiUtilsOptions optionsRequest;
    if (options != null) {
      optionsRequest = options;
    } else {
      optionsRequest = _getBaseOptions();
    }
    optionsRequest.method = "put";
    Completer<Response> completer = Completer();
    _doQueue(
        apiRequestModel: ApiRequestModel(
      completer: completer,
      path: path,
      options: optionsRequest,
      data: data,
      queryParameters: queryParameters,
    ));
    return completer.future;
  }

  _doQueue({ApiRequestModel? apiRequestModel}) async {
    if (apiRequestModel != null) apiQueryQueue.addLast(apiRequestModel);
    if (!isQueryingFirst) {
      if (!isRequestingRefreshToken) {
        // await first call api
        var firstItem = apiQueryQueue.removeFirst();
        isQueryingFirst = true;
        var isNeedRequestNewToken = await _query(
          path: firstItem.path,
          options: firstItem.options,
          completer: firstItem.completer,
        );
        if (isNeedRequestNewToken == true) {
          try {
            isRequestingRefreshToken = true;
            authToken = await callRefreshToken();
            apiQueryQueue.addFirst(firstItem);
            // call refresh token done
          } catch (err) {
            print("[Error] $err");
            // call refresh token failed
          } finally {
            isRequestingRefreshToken = false;
          }
        }
        isQueryingFirst = false;
      }
      while (apiQueryQueue.isNotEmpty) {
        var element = apiQueryQueue.removeFirst();
        _query(
          path: element.path,
          options: element.options,
          completer: element.completer,
          data: element.data,
          queryParameters: element.queryParameters,
        );
      }
    }
  }

  _query({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required ApiUtilsOptions options,
    required Completer<Response> completer,
  }) async {
    Completer<bool?> completerQuery = Completer();
    var header = options.headers;
    header?[Headers.wwwAuthenticateHeader] = authToken;
    options.headers = header;
    try {
      print("=======================================");
      print("[Method] : ${options.method}");
      print("[Path] : $path");
      print("[Header] : ${options.headers}");
      var result = await dio.request(path, data: data, options: options);
      print("[Status Code] ${result.statusCode}");
      print("[Result] ${result.data}");
      completer.complete(result);
      completerQuery.complete();
    } catch (err) {
      print("[Error] $err");
      if (err is DioError) {
        //check to refresh token
        if (err.response?.statusCode == 401 && authToken.isNotEmpty) {
          print("need refresh token");
          completerQuery.complete(true);
        } else {
          completer.completeError(err);
          completerQuery.complete();
        }
      } else {
        completer.completeError(err);
        completerQuery.complete();
      }
    }
    return completerQuery.future;
  }

  ApiUtilsOptions _getBaseOptions() {
    return ApiUtilsOptions();
  }

  Future<String> callRefreshToken() {
    return Future.value(
      "token",
    );
  }
}

class ApiUtilsOptions extends DioRequestOptions.Options {
  @override
  List<Object?> get props => [
        method,
        sendTimeout,
        receiveTimeout,
        extra,
        headers,
        responseType,
        contentType,
        validateStatus,
        receiveDataWhenStatusError,
        followRedirects,
        maxRedirects,
        requestEncoder,
        responseDecoder,
        listFormat,
      ];

  @override
  bool operator ==(Object other) {
    if (other is ApiUtilsOptions && other.runtimeType == runtimeType) {
      if (other.props.toString() == props.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  int get hashCode => props.toString().hashCode;
}

class ApiRequestModel {
  Completer<Response> completer;
  String path;
  Map<String, dynamic>? data;
  ApiUtilsOptions options;
  Map<String, dynamic>? queryParameters;

  ApiRequestModel({
    required this.completer,
    required this.path,
    this.data,
    this.queryParameters,
    required this.options,
  });
}
