import 'package:i_nhan_dao_2/models/business_error.dart';
import 'package:dio/dio.dart';
// class ServerException implements Exception {
//   BusinessError response;
//   ServerException(this.response);
// }

class ServerException extends DioError {
  BusinessError businessError;
  RequestOptions requestOptions;
  Response? response;
  DioExceptionType type;
  dynamic error;

  ServerException({
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
