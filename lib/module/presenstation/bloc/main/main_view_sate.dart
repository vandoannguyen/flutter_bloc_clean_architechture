import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';

class MainState extends BaseStateCubit {
  int? count = 0;
  String value = "value";

  MainState({this.count = 0, this.value = "value"});

  @override
  List<Object?> equal() {
    return [count];
  }

  MainState copyWith({count = 0, value}) {
    return MainState(count: count ?? this.count, value: value ?? this.value);
  }
}
