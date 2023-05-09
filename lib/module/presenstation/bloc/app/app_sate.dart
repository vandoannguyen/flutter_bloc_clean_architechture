// ignore: must_be_immutable
class AppState {
  int? count = 0;
  String value = "value";

  AppState({this.count = 0, this.value = "value"});

  @override
  List<Object?> equal() {
    return [count];
  }

  AppState copyWith({count = 0, value}) {
    return AppState(count: count ?? this.count, value: value ?? this.value);
  }
}
