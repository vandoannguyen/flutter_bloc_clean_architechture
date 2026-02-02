import 'package:dio/dio.dart';

import '../model/entity/error/business_error.dart';

class BusinessException extends DioException {
  BusinessError businessError;

  BusinessException({
    required this.businessError,
    required super.requestOptions,
    super.response,
    super.type = DioExceptionType.unknown,
    super.error,
  });
}
