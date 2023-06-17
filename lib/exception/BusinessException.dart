// import 'package:i_nhan_dao_2/models/business_error.dart';
// import 'package:dio/dio.dart';

// class BusinessException extends DioError {
//   BusinessError businessError;
//   RequestOptions requestOptions;
//   Response? response;
//   DioErrorType type;
//   dynamic? error;

//   // {
//   //   required this.requestOptions,
//   //   this.response,
//   //   this.type = DioErrorType.other,
//   //   this.error,
//   // }

//   BusinessException({
//     required this.businessError,
//     required this.requestOptions,
//     this.response,
//     this.type = DioErrorType.other,
//     this.error,
//   }) : super(this.requestOptions, this.response, this.type, this.error);
// }

import 'package:dio/dio.dart';

import '../model/entity/error/business_error.dart';

class BusinessException extends DioError {
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
