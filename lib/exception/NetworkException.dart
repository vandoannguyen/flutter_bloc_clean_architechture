import 'package:dio/dio.dart';

class NetworkException extends DioError {
  RequestOptions requestOptions;
  Response? response;
  DioExceptionType type;

  NetworkException({
    required this.requestOptions,
    this.response,
    this.type = DioExceptionType.unknown,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
        );
}
