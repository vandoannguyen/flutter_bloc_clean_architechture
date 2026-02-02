import 'package:dio/dio.dart';

class NetworkException extends DioException {
  NetworkException({
    required super.requestOptions,
    super.response,
    super.type,
  });
}
