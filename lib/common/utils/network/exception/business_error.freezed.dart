// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

BusinessError _$BusinessErrorFromJson(Map<String, dynamic> json) {
  return _BusinessError.fromJson(json);
}

/// @nodoc
mixin _$BusinessError {
  String? get errorCode => throw _privateConstructorUsedError;
  String? get errorData => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BusinessErrorCopyWith<BusinessError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BusinessErrorCopyWith<$Res> {
  factory $BusinessErrorCopyWith(
          BusinessError value, $Res Function(BusinessError) then) =
      _$BusinessErrorCopyWithImpl<$Res, BusinessError>;
  @useResult
  $Res call({String? errorCode, String? errorData, String? errorMessage});
}

/// @nodoc
class _$BusinessErrorCopyWithImpl<$Res, $Val extends BusinessError>
    implements $BusinessErrorCopyWith<$Res> {
  _$BusinessErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? errorData = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errorData: freezed == errorData
          ? _value.errorData
          : errorData // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_BusinessErrorCopyWith<$Res>
    implements $BusinessErrorCopyWith<$Res> {
  factory _$$_BusinessErrorCopyWith(
          _$_BusinessError value, $Res Function(_$_BusinessError) then) =
      __$$_BusinessErrorCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? errorCode, String? errorData, String? errorMessage});
}

/// @nodoc
class __$$_BusinessErrorCopyWithImpl<$Res>
    extends _$BusinessErrorCopyWithImpl<$Res, _$_BusinessError>
    implements _$$_BusinessErrorCopyWith<$Res> {
  __$$_BusinessErrorCopyWithImpl(
      _$_BusinessError _value, $Res Function(_$_BusinessError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? errorCode = freezed,
    Object? errorData = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$_BusinessError(
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      errorData: freezed == errorData
          ? _value.errorData
          : errorData // ignore: cast_nullable_to_non_nullable
              as String?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_BusinessError implements _BusinessError {
  const _$_BusinessError({this.errorCode, this.errorData, this.errorMessage});

  factory _$_BusinessError.fromJson(Map<String, dynamic> json) =>
      _$$_BusinessErrorFromJson(json);

  @override
  final String? errorCode;
  @override
  final String? errorData;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'BusinessError(errorCode: $errorCode, errorData: $errorData, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_BusinessError &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.errorData, errorData) ||
                other.errorData == errorData) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, errorCode, errorData, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BusinessErrorCopyWith<_$_BusinessError> get copyWith =>
      __$$_BusinessErrorCopyWithImpl<_$_BusinessError>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BusinessErrorToJson(
      this,
    );
  }
}

abstract class _BusinessError implements BusinessError {
  const factory _BusinessError(
      {final String? errorCode,
      final String? errorData,
      final String? errorMessage}) = _$_BusinessError;

  factory _BusinessError.fromJson(Map<String, dynamic> json) =
      _$_BusinessError.fromJson;

  @override
  String? get errorCode;
  @override
  String? get errorData;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$_BusinessErrorCopyWith<_$_BusinessError> get copyWith =>
      throw _privateConstructorUsedError;
}
