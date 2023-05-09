import 'package:dio/dio.dart';

import 'business_error.dart';
// class ServerException implements Exception {
//   BusinessError response;
//   ServerException(this.response);
// }

class ServerException extends DioError {
  BusinessError businessError;
  RequestOptions requestOptions;
  Response? response;
  DioErrorType type;
  dynamic error;

  ServerException({
    required this.businessError,
    required this.requestOptions,
    this.response,
    this.type = DioErrorType.unknown,
    this.error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );
}
