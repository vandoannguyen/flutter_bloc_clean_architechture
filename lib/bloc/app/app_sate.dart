import 'package:base_bloc_module/base/cubit/base_data_state_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_sate.freezed.dart';

@Freezed(equal: true)
class AppState extends BaseDataStateCubit  with _$AppState {
  factory AppState({
    @Default(0) int? count,
    @Default("value") String value,
  }) = _AppState;
}
