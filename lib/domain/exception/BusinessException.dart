import 'package:base_flutter_bloc/data/models/error/business_error.dart';
import 'package:dio/dio.dart';

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
