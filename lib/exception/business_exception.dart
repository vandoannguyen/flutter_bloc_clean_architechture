import 'package:dio/dio.dart';

import '../features/auth/data/models/business_error_model.dart';

class BusinessException extends DioException {
  BusinessErrorModel businessError;

  BusinessException({
    required this.businessError,
    required super.requestOptions,
    super.response,
    super.type = DioExceptionType.unknown,
    super.error,
  });
}
