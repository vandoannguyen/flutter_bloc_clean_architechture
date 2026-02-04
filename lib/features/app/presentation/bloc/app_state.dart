import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_state.freezed.dart';

@Freezed(equal: true)
abstract class AppState extends BaseDataStateCubit with _$AppState {
  AppState._();

  factory AppState() = _AppState;
}

@freezed
abstract class AppEvent extends BaseCubitEvent with _$AppEvent {
  AppEvent._();

  factory AppEvent.testTap() = TestTap;
}
