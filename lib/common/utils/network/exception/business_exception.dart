import 'package:dio/dio.dart';

import 'business_error.dart';

class BusinessException extends DioError {
  BusinessError businessError;
  RequestOptions requestOptions;
  Response? response;
  DioErrorType type;
  dynamic error;

  BusinessException({
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
