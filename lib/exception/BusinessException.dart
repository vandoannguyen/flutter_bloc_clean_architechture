import 'package:dio/dio.dart';

import '../model/entity/error/business_error.dart';

class BusinessException extends DioException {
  BusinessError businessError;
  RequestOptions requestOptions;
  Response? response;
  DioExceptionType type;
  dynamic error;

  BusinessException({
    required this.businessError,
    required this.requestOptions,
    this.response,
    this.type = DioExceptionType.unknown,
    this.error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );
}
