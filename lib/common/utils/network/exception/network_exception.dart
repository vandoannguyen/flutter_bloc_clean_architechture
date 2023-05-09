import 'package:dio/dio.dart';

class NetworkException extends DioError {
  RequestOptions requestOptions;
  Response? response;
  DioErrorType type;

  NetworkException({
    required this.requestOptions,
    this.response,
    this.type = DioErrorType.unknown,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
        );
}
