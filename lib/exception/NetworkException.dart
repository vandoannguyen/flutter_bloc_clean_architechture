import 'package:dio/dio.dart';

class NetworkException extends DioException {
  NetworkException({
    required RequestOptions requestOptions,
    Response? response,
    DioExceptionType type = DioExceptionType.unknown,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
        );
}
