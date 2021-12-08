import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';

class MainState extends BaseStateCubit {
  int? count = 0;
  String? value = "value";

  List<String>? listItem;

  MainState({this.count, this.value, this.listItem});

  @override
  List<Object?> equal() {
    return [count, value, listItem];
  }

  MainState copyWith({count, value, List<String>? listItem}) {
    return MainState(
      count: count ?? this.count,
      value: value ?? this.value,
      listItem: listItem ?? this.listItem,
    );
  }
}
