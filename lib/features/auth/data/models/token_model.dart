import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/token/token_entity.dart';

part 'token_model.freezed.dart';
part 'token_model.g.dart';

/// Token data model for JSON serialization.
/// 
/// This is the data layer representation of authentication tokens.
/// Use TokenEntity in domain layer.
@freezed
class TokenModel with _$TokenModel {
  const factory TokenModel({
    @JsonKey(name: 'access_token') String? accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'expire_at') int? expireAt,
    @JsonKey(name: 'token_type') String? tokenType,
  }) = _TokenModel;

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);
}

/// Extension to convert TokenModel to TokenEntity.
extension TokenModelExtension on TokenModel {
  /// Converts TokenModel to TokenEntity.
  TokenEntity toEntity() {
    return TokenEntity(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expireAt: expireAt,
      tokenType: tokenType,
    );
  }
}
