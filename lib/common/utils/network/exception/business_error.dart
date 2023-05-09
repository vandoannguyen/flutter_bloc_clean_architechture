import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_error.freezed.dart';
part 'business_error.g.dart';
@freezed
class BusinessError with _$BusinessError {
  @JsonSerializable(explicitToJson: true)
  const factory BusinessError(
      {String? errorCode,
      String? errorData,
      String? errorMessage}) = _BusinessError;
  @JsonSerializable(explicitToJson: true)
  factory BusinessError.fromJson(Map<String, Object?> json)
  => _$BusinessErrorFromJson(json);
}
