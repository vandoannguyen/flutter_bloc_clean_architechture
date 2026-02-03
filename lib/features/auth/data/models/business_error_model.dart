import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/error/business_error_entity.dart';

part 'business_error_model.g.dart';

/// Business error data model for JSON serialization.
/// 
/// This is the data layer representation of business errors.
/// Use BusinessErrorEntity in domain layer.
@JsonSerializable(explicitToJson: true)
class BusinessErrorModel {
  int? code;
  @JsonKey(name: 'error_code')
  String? errorCode;
  @JsonKey(name: 'error_data')
  dynamic errorData;
  @JsonKey(name: 'error_message')
  String? errorMessage;

  BusinessErrorModel({
    this.code,
    this.errorCode,
    this.errorData,
    this.errorMessage,
  });

  factory BusinessErrorModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$BusinessErrorModelToJson(this);
}

/// Extension to convert BusinessErrorModel to BusinessErrorEntity.
extension BusinessErrorModelExtension on BusinessErrorModel {
  /// Converts BusinessErrorModel to BusinessErrorEntity.
  BusinessErrorEntity toEntity() {
    return BusinessErrorEntity(
      code: code,
      errorCode: errorCode,
      errorData: errorData,
      errorMessage: errorMessage,
    );
  }
}
