import 'package:dio/dio.dart';
import '../model/entity/error/business_error.dart';

class ServerException extends DioException {
  BusinessError businessError;

  ServerException({
    required this.businessError,
    required super.requestOptions,
    super.response,
    super.type,
    dynamic super.error,
  });
}
