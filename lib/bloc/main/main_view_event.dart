import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';

part 'main_view_event.freezed.dart';

@freezed
class MainViewEvent extends BaseCubitEvent with _$MainViewEvent {
  const factory MainViewEvent.getData() = GetData;

  const factory MainViewEvent.showMessage() = ShowMessage;
}
