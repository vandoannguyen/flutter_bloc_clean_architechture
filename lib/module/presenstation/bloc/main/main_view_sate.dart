import 'package:base_bloc_module/base/base_state.dart';

class MainState extends BaseState {
  int? count = 0;

  MainState({this.count = 0});

  @override
  List<Object?> equal() {
    return [count];
  }

  MainState copyWith({count = 0}) {
    return MainState(count: count ?? this.count);
  }
}
