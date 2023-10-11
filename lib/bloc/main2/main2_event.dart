import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';

part 'main2_event.freezed.dart';

@freezed
class Main2ViewEvent extends BaseCubitEvent with _$Main2ViewEvent {
  const factory Main2ViewEvent.getData() = GetData;

  const factory Main2ViewEvent.showMessage() = ShowMessage;
}
