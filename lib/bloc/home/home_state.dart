import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

@Freezed(equal: true)
class HomeState extends BaseDataStateCubit with _$HomeState {
  HomeState._();

  factory HomeState({@Default(0) int count}) = _HomeState;

  @override
  // TODO: implement count
  int get count => throw UnimplementedError();
}

@freezed
class HomeEvent extends BaseCubitEvent with _$HomeEvent {
  HomeEvent._();

  factory HomeEvent.getData() = GetData;
}
