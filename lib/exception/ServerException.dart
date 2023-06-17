import 'package:dio/dio.dart';
import '../model/entity/error/business_error.dart';

class ServerException extends DioException {
  BusinessError businessError;

  ServerException({
    required this.businessError,
    required RequestOptions requestOptions,
    Response? response,
    DioExceptionType type = DioExceptionType.unknown,
    dynamic error,
  }) : super(
          requestOptions: requestOptions,
          response: response,
          type: type,
          error: error,
        );
}
