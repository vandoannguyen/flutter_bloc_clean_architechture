import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:http/http.dart';

class ApiUtils {
  ListQueue<ApiRequestModel> apiQueryQueue = ListQueue();
  String host = "https://host";
  String authToken = "";
  String refreshToken = "";
  late Client client;
  static final ApiUtils instance = ApiUtils._getInstance();

  bool isRequestingRefreshToken = false;
  bool isQueryingFirst = false;

  ApiUtils._getInstance();

  void setBaseUrl(String url) {
    host = url;
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    Completer<Response> completer = Completer();
    _doQueue(
        apiRequestModel: ApiRequestModel(
      completer: completer,
      path: path,
      header: header ?? _getBaseHeader(),
      queryParameters: queryParameters,
      method: RequestMethod.GET,
    ));
    return completer.future;
  }

  Future<Response> post(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    Completer<Response> completer = Completer();
    _doQueue(
      apiRequestModel: ApiRequestModel(
        completer: completer,
        path: path,
        header: header ?? _getBaseHeader(),
        data: data,
        queryParameters: queryParameters,
        method: RequestMethod.POST,
      ),
    );
    return completer.future;
  }

  Future<Response> delete(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    Completer<Response> completer = Completer();
    _doQueue(
        apiRequestModel: ApiRequestModel(
      completer: completer,
      path: path,
      header: header ?? _getBaseHeader(),
      data: data,
      queryParameters: queryParameters,
      method: RequestMethod.DELETE,
    ));
    return completer.future;
  }

  Future<Response> put(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? header,
  }) {
    Completer<Response> completer = Completer();
    _doQueue(
        apiRequestModel: ApiRequestModel(
            completer: completer,
            path: path,
            header: header ?? _getBaseHeader(),
            data: data,
            queryParameters: queryParameters,
            method: RequestMethod.PUT));
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
          header: firstItem.header,
          completer: firstItem.completer,
          method: firstItem.method,
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
          header: element.header,
          completer: element.completer,
          data: element.data,
          queryParameters: element.queryParameters,
          method: element.method,
        );
      }
    }
  }

  _query({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required Map<String, String> header,
    required Completer<Response> completer,
    required RequestMethod method,
  }) async {
    Completer<bool?> completerQuery = Completer();
    header["Authorization"] = authToken;
    try {
      client = getClient();
      Response result = await _callMethod(
        path: path,
        header: header,
        completer: completer,
        method: method,
        data: data,
        queryParameters: queryParameters,
      );
      if (result.statusCode == 401) throw (401);
      completer.complete(result);
      completerQuery.complete();
    } catch (err) {
      print("[Error] $err");
      if (err == 401) {
        //check to refresh token
        if (authToken.isNotEmpty) {
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
    } finally {
      client.close();
    }
    return completerQuery.future;
  }

  Map<String, String> _getBaseHeader() {
    return {};
  }

  Future<String> callRefreshToken() {
    return Future.value(
      "token",
    );
  }

  Client getClient() {
    return Platform.environment.containsKey('FLUTTER_TEST') ? client : Client();
  }

  Future<Response> _callMethod({
    required String path,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    required Map<String, String> header,
    required Completer<Response> completer,
    required RequestMethod method,
  }) async {
    print("=======================================");
    print("[Method] : $method");
    print("[Path] : $path");
    print("[Header] : $header");
    late Response result;
    switch (method) {
      case RequestMethod.GET:
        result = await client.get(Uri.parse("$host/$path"), headers: header);
        break;
      case RequestMethod.PUT:
        result = await client.put(
          Uri.parse("$host/$path"),
          headers: header,
          body: data,
        );
        break;
      case RequestMethod.POST:
        result = await client.post(
          Uri.parse("$host/$path"),
          headers: header,
          body: data,
        );
        break;
      case RequestMethod.DELETE:
        result = await client.delete(
          Uri.parse("$host/$path"),
          headers: header,
          body: data,
        );
        break;
    }
    print("[Status Code] ${result.statusCode}");
    print("[Result] ${result.body}");
    return result;
  }
}

class ApiRequestModel {
  Completer<Response> completer;
  String path;
  Map<String, dynamic>? data;
  Map<String, String> header;
  Map<String, dynamic>? queryParameters;
  RequestMethod method;

  ApiRequestModel({
    required this.completer,
    required this.path,
    this.data,
    this.queryParameters,
    required this.header,
    required this.method,
  });
}

enum RequestMethod { GET, PUT, POST, DELETE }
