import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/counter_entity.dart';

part 'home_state.freezed.dart';

@Freezed(equal: true)
abstract class HomeState extends BaseDataStateCubit with _$HomeState {
  HomeState._();

  factory HomeState({
    @Default(CounterEntity(count: 0)) CounterEntity counter,
  }) = _HomeState;
}

@Freezed(equal: false)
abstract class HomeEvent extends BaseCubitEvent with _$HomeEvent {
  HomeEvent._();

  factory HomeEvent.increment() = Increment;
}
