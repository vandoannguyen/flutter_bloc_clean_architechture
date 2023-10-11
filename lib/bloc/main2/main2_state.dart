import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'main2_state.freezed.dart';

@Freezed(equal: true)
class Main2State extends BaseStateCubit with _$Main2State {
  factory Main2State({
    @Default(0) int? count,
    @Default("value") String value,
  }) = _Main2State;
}
