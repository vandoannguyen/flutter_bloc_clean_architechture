import 'package:base_bloc_module/base/bloc/base_state.dart';

class MainState extends BaseState {
  int? count = 0;
  String value = "value";
  Test? test;
  List<String>? listItem;

  MainState(
      {this.count = 0,
      this.value = "value",
      this.test,
      this.listItem = const []});

  @override
  List<Object?> equal() {
    return [count, value, test, listItem];
  }

  MainState copyWith({count, value, Test? test, List<String>? listItem}) {
    List<String>? list = [];
    if (listItem != null) {
      list.addAll(listItem);
    } else {
      list = this.listItem;
    }
    var state = MainState(
      count: count ?? this.count,
      value: value ?? this.value,
      test: test ?? this.test,
      listItem: list,
    );
    return state;
  }

  MainState addItemList(data) {
    List<String> list = [];
    list.addAll(listItem ?? []);
    list.add(data);
    return copyWith(listItem: list);
  }

  MainState setList(List<String> list) {
    return copyWith(listItem: list);
  }
}

class Test {
  final String? name1, name2;

  const Test({this.name2 = "", this.name1 = ""});
}
