// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'main_view_sate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MainState {
  int? get count => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;
  ContentModel? get user => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MainStateCopyWith<MainState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainStateCopyWith<$Res> {
  factory $MainStateCopyWith(MainState value, $Res Function(MainState) then) =
      _$MainStateCopyWithImpl<$Res>;
  $Res call({int? count, String value, ContentModel? user});

  $ContentModelCopyWith<$Res>? get user;
}

/// @nodoc
class _$MainStateCopyWithImpl<$Res> implements $MainStateCopyWith<$Res> {
  _$MainStateCopyWithImpl(this._value, this._then);

  final MainState _value;
  // ignore: unused_field
  final $Res Function(MainState) _then;

  @override
  $Res call({
    Object? count = freezed,
    Object? value = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ContentModel?,
    ));
  }

  @override
  $ContentModelCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $ContentModelCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
abstract class _$MainStateCopyWith<$Res> implements $MainStateCopyWith<$Res> {
  factory _$MainStateCopyWith(
          _MainState value, $Res Function(_MainState) then) =
      __$MainStateCopyWithImpl<$Res>;
  @override
  $Res call({int? count, String value, ContentModel? user});

  @override
  $ContentModelCopyWith<$Res>? get user;
}

/// @nodoc
class __$MainStateCopyWithImpl<$Res> extends _$MainStateCopyWithImpl<$Res>
    implements _$MainStateCopyWith<$Res> {
  __$MainStateCopyWithImpl(_MainState _value, $Res Function(_MainState) _then)
      : super(_value, (v) => _then(v as _MainState));

  @override
  _MainState get _value => super._value as _MainState;

  @override
  $Res call({
    Object? count = freezed,
    Object? value = freezed,
    Object? user = freezed,
  }) {
    return _then(_MainState(
      count: count == freezed
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      value: value == freezed
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as ContentModel?,
    ));
  }
}

/// @nodoc

class _$_MainState implements _MainState {
  _$_MainState({this.count = 0, this.value = "value", this.user});

  @override
  @JsonKey()
  final int? count;
  @override
  @JsonKey()
  final String value;
  @override
  final ContentModel? user;

  @override
  String toString() {
    return 'MainState(count: $count, value: $value, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MainState &&
            const DeepCollectionEquality().equals(other.count, count) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(count),
      const DeepCollectionEquality().hash(value),
      const DeepCollectionEquality().hash(user));

  @JsonKey(ignore: true)
  @override
  _$MainStateCopyWith<_MainState> get copyWith =>
      __$MainStateCopyWithImpl<_MainState>(this, _$identity);
}

abstract class _MainState implements MainState {
  factory _MainState(
      {final int? count,
      final String value,
      final ContentModel? user}) = _$_MainState;

  @override
  int? get count => throw _privateConstructorUsedError;
  @override
  String get value => throw _privateConstructorUsedError;
  @override
  ContentModel? get user => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MainStateCopyWith<_MainState> get copyWith =>
      throw _privateConstructorUsedError;
}
