// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_view_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MainViewEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getData,
    required TResult Function() showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getData,
    TResult? Function()? showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getData,
    TResult Function()? showMessage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetData value) getData,
    required TResult Function(ShowMessage value) showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetData value)? getData,
    TResult? Function(ShowMessage value)? showMessage,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetData value)? getData,
    TResult Function(ShowMessage value)? showMessage,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MainViewEventCopyWith<$Res> {
  factory $MainViewEventCopyWith(
          MainViewEvent value, $Res Function(MainViewEvent) then) =
      _$MainViewEventCopyWithImpl<$Res, MainViewEvent>;
}

/// @nodoc
class _$MainViewEventCopyWithImpl<$Res, $Val extends MainViewEvent>
    implements $MainViewEventCopyWith<$Res> {
  _$MainViewEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GetDataCopyWith<$Res> {
  factory _$$GetDataCopyWith(_$GetData value, $Res Function(_$GetData) then) =
      __$$GetDataCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GetDataCopyWithImpl<$Res>
    extends _$MainViewEventCopyWithImpl<$Res, _$GetData>
    implements _$$GetDataCopyWith<$Res> {
  __$$GetDataCopyWithImpl(_$GetData _value, $Res Function(_$GetData) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GetData implements GetData {
  const _$GetData();

  @override
  String toString() {
    return 'MainViewEvent.getData()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GetData);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getData,
    required TResult Function() showMessage,
  }) {
    return getData();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getData,
    TResult? Function()? showMessage,
  }) {
    return getData?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getData,
    TResult Function()? showMessage,
    required TResult orElse(),
  }) {
    if (getData != null) {
      return getData();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetData value) getData,
    required TResult Function(ShowMessage value) showMessage,
  }) {
    return getData(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetData value)? getData,
    TResult? Function(ShowMessage value)? showMessage,
  }) {
    return getData?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetData value)? getData,
    TResult Function(ShowMessage value)? showMessage,
    required TResult orElse(),
  }) {
    if (getData != null) {
      return getData(this);
    }
    return orElse();
  }
}

abstract class GetData implements MainViewEvent {
  const factory GetData() = _$GetData;
}

/// @nodoc
abstract class _$$ShowMessageCopyWith<$Res> {
  factory _$$ShowMessageCopyWith(
          _$ShowMessage value, $Res Function(_$ShowMessage) then) =
      __$$ShowMessageCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ShowMessageCopyWithImpl<$Res>
    extends _$MainViewEventCopyWithImpl<$Res, _$ShowMessage>
    implements _$$ShowMessageCopyWith<$Res> {
  __$$ShowMessageCopyWithImpl(
      _$ShowMessage _value, $Res Function(_$ShowMessage) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ShowMessage implements ShowMessage {
  const _$ShowMessage();

  @override
  String toString() {
    return 'MainViewEvent.showMessage()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ShowMessage);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() getData,
    required TResult Function() showMessage,
  }) {
    return showMessage();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? getData,
    TResult? Function()? showMessage,
  }) {
    return showMessage?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? getData,
    TResult Function()? showMessage,
    required TResult orElse(),
  }) {
    if (showMessage != null) {
      return showMessage();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GetData value) getData,
    required TResult Function(ShowMessage value) showMessage,
  }) {
    return showMessage(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GetData value)? getData,
    TResult? Function(ShowMessage value)? showMessage,
  }) {
    return showMessage?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GetData value)? getData,
    TResult Function(ShowMessage value)? showMessage,
    required TResult orElse(),
  }) {
    if (showMessage != null) {
      return showMessage(this);
    }
    return orElse();
  }
}

abstract class ShowMessage implements MainViewEvent {
  const factory ShowMessage() = _$ShowMessage;
}
