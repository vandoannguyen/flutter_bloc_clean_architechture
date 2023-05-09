import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_info.freezed.dart';
part 'token_info.g.dart';
@freezed
class TokenInfo with _$TokenInfo {
  factory TokenInfo({
    @JsonKey(name: "access_token") String? accessToken,
    @JsonKey(name: "refresh_token") String? refreshToken,
  }) = _TokenInfo;
  @JsonSerializable(explicitToJson: true)
  factory TokenInfo.fromJson(Map<String, Object?> json) =>
      _$TokenInfoFromJson(json);
}
