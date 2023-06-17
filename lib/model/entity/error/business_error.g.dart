// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessError _$BusinessErrorFromJson(Map<String, dynamic> json) =>
    BusinessError(
      code: json['code'] as int?,
      errorCode: json['error_code'] as String?,
      errorData: json['error_data'],
      errorMessage: json['error_message'] as String?,
    );

Map<String, dynamic> _$BusinessErrorToJson(BusinessError instance) =>
    <String, dynamic>{
      'code': instance.code,
      'error_code': instance.errorCode,
      'error_data': instance.errorData,
      'error_message': instance.errorMessage,
    };
