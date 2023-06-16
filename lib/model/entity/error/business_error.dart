import 'package:json_annotation/json_annotation.dart';
part 'business_error.g.dart';

@JsonSerializable()
class BusinessError {
  int code;
  @JsonKey(name: 'error_code')
  String errorCode;
  @JsonKey(name: 'error_data')
  dynamic errorData;
  @JsonKey(name: 'error_message')
  String? errorMessage;

  BusinessError({
    required this.code,
    required this.errorCode,
    this.errorData,
    this.errorMessage,
  });

  factory BusinessError.fromJson(Map<String, dynamic> json) =>
      _$BusinessErrorFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessErrorToJson(this);
}
