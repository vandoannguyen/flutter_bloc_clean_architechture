import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/token/token_entity.dart';

part 'token_model.g.dart';

/// Token data model for JSON serialization.
/// 
/// This is the data layer representation of authentication tokens.
/// Use TokenEntity in domain layer.
@JsonSerializable(explicitToJson: true)
class TokenModel {
  @JsonKey(name: 'access_token')
  final String? accessToken;
  @JsonKey(name: 'refresh_token')
  final String? refreshToken;
  @JsonKey(name: 'expire_at')
  final int? expireAt;
  @JsonKey(name: 'token_type')
  final String? tokenType;

  TokenModel({
    this.accessToken,
    this.refreshToken,
    this.expireAt,
    this.tokenType,
  });

  factory TokenModel.fromJson(Map<String, dynamic> json) =>
      _$TokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenModelToJson(this);
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
