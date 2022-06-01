// ignore: library_prefixes
import 'package:baese_flutter_bloc/common/utils/api_utils.dart'; // import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group("test call api", () {
    test("not need refresh token", () {
      ApiUtils apiUtils = ApiUtils.instance;
      apiUtils.client = ClientMock();
      String path1 = "part1";
      String path2 = "part2";
      String authToken = "authToken";
      apiUtils.authToken = authToken;
      Map<String, dynamic> paramaters = {};
      // Response response =
      Response response1 = Response("", 100);
      Response response2 = Response("", 100);
      when(
        () => apiUtils.client.get(
          Uri.parse("https://host/$path1"),
          headers: {"Authorization": authToken},
        ),
      ).thenAnswer((invocation) async => response1);
      when(
        () => apiUtils.client.get(
          Uri.parse("https://host/$path2"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((invocation) async => response2);
      when(
        () => apiUtils.client.put(
          Uri.parse("https://host/$path2"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((invocation) async => response2);
      when(
        () => apiUtils.client.post(
          Uri.parse("https://host/$path2"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((invocation) async => response2);
      when(
        () => apiUtils.client.delete(
          Uri.parse("https://host/$path2"),
          headers: any(named: "headers"),
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
      apiUtils.put(path2).then((value) {
        expect(value, response2);
        expect(apiUtils.authToken, authToken);
      });
      apiUtils.post(path2).then((value) {
        expect(value, response2);
        expect(apiUtils.authToken, authToken);
      });
      apiUtils.delete(path2).then((value) {
        expect(value, response2);
        expect(apiUtils.authToken, authToken);
      });
    });
    test("need refresh token", () {
      ApiUtils apiUtils = ApiUtils.instance;
      apiUtils.client = ClientMock();
      String path1 = "path1";
      String path2 = "path2";
      String authToken = "authToken1";
      String refreshAuthToken = "token";
      apiUtils.authToken = authToken;
      Response response401 = Response("", 401);
      Response response1 = Response("", 100);
      Response response2 = Response("", 100);
      when(
        () => apiUtils.client.get(
          Uri.parse("https://host/$path1"),
          headers: {"Authorization": authToken},
        ),
      ).thenAnswer((invocation) async => response401);
      when(
        () => apiUtils.client.get(
          Uri.parse("https://host/$path1"),
          headers: {"Authorization": refreshAuthToken},
        ),
      ).thenAnswer((invocation) async => response1);
      when(
        () => apiUtils.client.get(
          Uri.parse("https://host/$path2"),
          headers: any(named: "headers"),
        ),
      ).thenAnswer((invocation) async => response2);
      apiUtils.get(path1, header: {"Authorization": authToken}).then((value) {
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

class ClientMock with Mock implements Client {}
