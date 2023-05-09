// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) {
  return _TokenInfo.fromJson(json);
}

/// @nodoc
mixin _$TokenInfo {
  @JsonKey(name: "access_token")
  String? get accessToken => throw _privateConstructorUsedError;
  @JsonKey(name: "refresh_token")
  String? get refreshToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TokenInfoCopyWith<TokenInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TokenInfoCopyWith<$Res> {
  factory $TokenInfoCopyWith(TokenInfo value, $Res Function(TokenInfo) then) =
      _$TokenInfoCopyWithImpl<$Res, TokenInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: "access_token") String? accessToken,
      @JsonKey(name: "refresh_token") String? refreshToken});
}

/// @nodoc
class _$TokenInfoCopyWithImpl<$Res, $Val extends TokenInfo>
    implements $TokenInfoCopyWith<$Res> {
  _$TokenInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TokenInfoCopyWith<$Res> implements $TokenInfoCopyWith<$Res> {
  factory _$$_TokenInfoCopyWith(
          _$_TokenInfo value, $Res Function(_$_TokenInfo) then) =
      __$$_TokenInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "access_token") String? accessToken,
      @JsonKey(name: "refresh_token") String? refreshToken});
}

/// @nodoc
class __$$_TokenInfoCopyWithImpl<$Res>
    extends _$TokenInfoCopyWithImpl<$Res, _$_TokenInfo>
    implements _$$_TokenInfoCopyWith<$Res> {
  __$$_TokenInfoCopyWithImpl(
      _$_TokenInfo _value, $Res Function(_$_TokenInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? refreshToken = freezed,
  }) {
    return _then(_$_TokenInfo(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      refreshToken: freezed == refreshToken
          ? _value.refreshToken
          : refreshToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TokenInfo implements _TokenInfo {
  _$_TokenInfo(
      {@JsonKey(name: "access_token") this.accessToken,
      @JsonKey(name: "refresh_token") this.refreshToken});

  factory _$_TokenInfo.fromJson(Map<String, dynamic> json) =>
      _$$_TokenInfoFromJson(json);

  @override
  @JsonKey(name: "access_token")
  final String? accessToken;
  @override
  @JsonKey(name: "refresh_token")
  final String? refreshToken;

  @override
  String toString() {
    return 'TokenInfo(accessToken: $accessToken, refreshToken: $refreshToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TokenInfo &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, accessToken, refreshToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TokenInfoCopyWith<_$_TokenInfo> get copyWith =>
      __$$_TokenInfoCopyWithImpl<_$_TokenInfo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TokenInfoToJson(
      this,
    );
  }
}

abstract class _TokenInfo implements TokenInfo {
  factory _TokenInfo(
          {@JsonKey(name: "access_token") final String? accessToken,
          @JsonKey(name: "refresh_token") final String? refreshToken}) =
      _$_TokenInfo;

  factory _TokenInfo.fromJson(Map<String, dynamic> json) =
      _$_TokenInfo.fromJson;

  @override
  @JsonKey(name: "access_token")
  String? get accessToken;
  @override
  @JsonKey(name: "refresh_token")
  String? get refreshToken;
  @override
  @JsonKey(ignore: true)
  _$$_TokenInfoCopyWith<_$_TokenInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
