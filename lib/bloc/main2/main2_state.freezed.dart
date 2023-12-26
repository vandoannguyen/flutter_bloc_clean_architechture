// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main2_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Main2State {
  int? get count => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $Main2StateCopyWith<Main2State> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Main2StateCopyWith<$Res> {
  factory $Main2StateCopyWith(
          Main2State value, $Res Function(Main2State) then) =
      _$Main2StateCopyWithImpl<$Res, Main2State>;
  @useResult
  $Res call({int? count, String value});
}

/// @nodoc
class _$Main2StateCopyWithImpl<$Res, $Val extends Main2State>
    implements $Main2StateCopyWith<$Res> {
  _$Main2StateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Main2StateImplCopyWith<$Res>
    implements $Main2StateCopyWith<$Res> {
  factory _$$Main2StateImplCopyWith(
          _$Main2StateImpl value, $Res Function(_$Main2StateImpl) then) =
      __$$Main2StateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? count, String value});
}

/// @nodoc
class __$$Main2StateImplCopyWithImpl<$Res>
    extends _$Main2StateCopyWithImpl<$Res, _$Main2StateImpl>
    implements _$$Main2StateImplCopyWith<$Res> {
  __$$Main2StateImplCopyWithImpl(
      _$Main2StateImpl _value, $Res Function(_$Main2StateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = freezed,
    Object? value = null,
  }) {
    return _then(_$Main2StateImpl(
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$Main2StateImpl implements _Main2State {
  _$Main2StateImpl({this.count = 0, this.value = "value"});

  @override
  @JsonKey()
  final int? count;
  @override
  @JsonKey()
  final String value;

  @override
  String toString() {
    return 'Main2State(count: $count, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Main2StateImpl &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, count, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$Main2StateImplCopyWith<_$Main2StateImpl> get copyWith =>
      __$$Main2StateImplCopyWithImpl<_$Main2StateImpl>(this, _$identity);
}

abstract class _Main2State implements Main2State {
  factory _Main2State({final int? count, final String value}) =
      _$Main2StateImpl;

  @override
  int? get count;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$Main2StateImplCopyWith<_$Main2StateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
