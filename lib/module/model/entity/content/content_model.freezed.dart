// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'content_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ContentModel {
  String? get   a => throw _privateConstructorUsedError;
  String? get b => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ContentModelCopyWith<ContentModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentModelCopyWith<$Res> {
  factory $ContentModelCopyWith(
          ContentModel value, $Res Function(ContentModel) then) =
      _$ContentModelCopyWithImpl<$Res>;
  $Res call({String? a, String? b});
}

/// @nodoc
class _$ContentModelCopyWithImpl<$Res> implements $ContentModelCopyWith<$Res> {
  _$ContentModelCopyWithImpl(this._value, this._then);

  final ContentModel _value;
  // ignore: unused_field
  final $Res Function(ContentModel) _then;

  @override
  $Res call({
    Object? a = freezed,
    Object? b = freezed,
  }) {
    return _then(_value.copyWith(
      a: a == freezed
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as String?,
      b: b == freezed
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$ContentModelCopyWith<$Res>
    implements $ContentModelCopyWith<$Res> {
  factory _$ContentModelCopyWith(
          _ContentModel value, $Res Function(_ContentModel) then) =
      __$ContentModelCopyWithImpl<$Res>;
  @override
  $Res call({String? a, String? b});
}

/// @nodoc
class __$ContentModelCopyWithImpl<$Res> extends _$ContentModelCopyWithImpl<$Res>
    implements _$ContentModelCopyWith<$Res> {
  __$ContentModelCopyWithImpl(
      _ContentModel _value, $Res Function(_ContentModel) _then)
      : super(_value, (v) => _then(v as _ContentModel));

  @override
  _ContentModel get _value => super._value as _ContentModel;

  @override
  $Res call({
    Object? a = freezed,
    Object? b = freezed,
  }) {
    return _then(_ContentModel(
      a: a == freezed
          ? _value.a
          : a // ignore: cast_nullable_to_non_nullable
              as String?,
      b: b == freezed
          ? _value.b
          : b // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_ContentModel implements _ContentModel {
  _$_ContentModel({this.a, this.b});

  @override
  final String? a;
  @override
  final String? b;

  @override
  String toString() {
    return 'ContentModel(a: $a, b: $b)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ContentModel &&
            const DeepCollectionEquality().equals(other.a, a) &&
            const DeepCollectionEquality().equals(other.b, b));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(a),
      const DeepCollectionEquality().hash(b));

  @JsonKey(ignore: true)
  @override
  _$ContentModelCopyWith<_ContentModel> get copyWith =>
      __$ContentModelCopyWithImpl<_ContentModel>(this, _$identity);
}

abstract class _ContentModel implements ContentModel {
  factory _ContentModel({final String? a, final String? b}) = _$_ContentModel;

  @override
  String? get a => throw _privateConstructorUsedError;
  @override
  String? get b => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$ContentModelCopyWith<_ContentModel> get copyWith =>
      throw _privateConstructorUsedError;
}
