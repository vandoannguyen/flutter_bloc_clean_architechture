import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.freezed.dart';

@freezed
class AppEvent extends BaseCubitEvent with _$AppEvent {
  const factory AppEvent.getData() = GetData;

  const factory AppEvent.showMessage() = ShowMessage;
}
