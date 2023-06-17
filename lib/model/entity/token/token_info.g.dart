// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) => TokenInfo(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      expireAt: json['expire_at'] as int?,
      tokenType: json['token_type'] as String?,
    );

Map<String, dynamic> _$TokenInfoToJson(TokenInfo instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expire_at': instance.expireAt,
      'token_type': instance.tokenType,
    };
