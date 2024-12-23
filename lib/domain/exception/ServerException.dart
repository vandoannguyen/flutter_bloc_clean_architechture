import 'package:base_flutter_bloc/data/models/error/business_error.dart';
import 'package:dio/dio.dart';

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
