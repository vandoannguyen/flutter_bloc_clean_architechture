import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_sate.freezed.dart';

@Freezed(equal: true)
class AppState extends BaseDataStateCubit with _$AppState {
  AppState._();

  factory AppState() = _AppState;
}

@freezed
class AppEvent extends BaseCubitEvent with _$AppEvent {
  AppEvent._();

  factory AppEvent.getData() = GetData;
}