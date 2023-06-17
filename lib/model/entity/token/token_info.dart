import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info.g.dart';

@JsonSerializable(explicitToJson: true)
class TokenInfo {
  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'refresh_token')
  String? refreshToken;
  @JsonKey(name: 'expire_at')
  int? expireAt;
  @JsonKey(name: 'token_type')
  String? tokenType;

  TokenInfo({
    required this.accessToken,
    required this.refreshToken,
    required this.expireAt,
    required this.tokenType,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);
}
