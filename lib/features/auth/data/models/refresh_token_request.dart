import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request.g.dart';

/// Refresh token request model for API calls.
@JsonSerializable()
class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest(this.refreshToken);

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);
}
