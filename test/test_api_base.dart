// ignore: library_prefixes
import 'package:baese_flutter_bloc/common/utils/api_utils.dart'
    as apiRequestUtils;
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group("test call api", () {
    test("not need refresh token", () {
      apiRequestUtils.ApiUtils apiUtils = apiRequestUtils.ApiUtils.instance;
      apiUtils.dio = DioMock();
      String path1 = "path1";
      String path2 = "path2";
      String authToken = "authToken";
      apiUtils.authToken = authToken;
      Map<String, dynamic> paramaters = {};
      Response response1 = Response(
        requestOptions: RequestOptions(path: path1),
        statusCode: 100,
        data: {},
      );
      Response response2 = Response(
        requestOptions: RequestOptions(path: path2),
        statusCode: 100,
        data: {},
      );
      when(
        () => apiUtils.dio.request(
          path1,
          options: any(named: "options"),
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer((invocation) async => response1);
      when(
        () => apiUtils.dio.request(
          path2,
          options: any(named: "options"),
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer((invocation) async => response2);
      apiUtils.get(path1).then((value) {
        expect(value, response1);
        expect(apiUtils.authToken, authToken);
      });
      apiUtils.get(path2).then((value) {
        expect(value, response2);
        expect(apiUtils.authToken, authToken);
      });
    });
    test("need refresh token", () {
      apiRequestUtils.ApiUtils apiUtils = apiRequestUtils.ApiUtils.instance;
      apiUtils.dio = DioMock();
      String path1 = "path1";
      String path2 = "path2";
      String authToken = "authToken1";
      String refreshAuthToken = "token";
      apiUtils.authToken = authToken;
      Response response401 = Response(
        requestOptions: RequestOptions(path: path1),
        statusCode: 401,
      );
      Response response1 = Response(
        requestOptions: RequestOptions(path: path1),
        statusCode: 100,
      );
      Response response2 = Response(
        requestOptions: RequestOptions(path: path2),
        statusCode: 100,
      );
      when(
        () => apiUtils.dio.request(
          path1,
          options: apiRequestUtils.Options()
            ..method = "get"
            ..headers = {
              Headers.wwwAuthenticateHeader: authToken,
            },
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenThrow(
        DioError(
          requestOptions: RequestOptions(path: path1),
          response: response401,
          error: "error",
        ),
      );
      when(
        () => apiUtils.dio.request(
          path1,
          options: apiRequestUtils.Options()
            ..method = "get"
            ..headers = {
              Headers.wwwAuthenticateHeader: refreshAuthToken,
            },
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer((invocation) async => response1);
      when(
        () => apiUtils.dio.request(
          path2,
          options: any(named: "options"),
          queryParameters: any(named: "queryParameters"),
        ),
      ).thenAnswer((invocation) async => response2);
      apiUtils
          .get(path1,
              options: apiRequestUtils.Options()
                ..method = "get"
                ..headers = {
                  Headers.wwwAuthenticateHeader: authToken,
                })
          .then((value) {
        expect(value, response1);
        expect(apiUtils.authToken != authToken, true);
      });
      apiUtils.get(path2).then((value) {
        expect(value, response2);
        expect(apiUtils.authToken != authToken, true);
      });
    });
  });
}

class DioMock with Mock implements Dio {}
