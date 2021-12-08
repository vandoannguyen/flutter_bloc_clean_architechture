import 'dart:async';

import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_event.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:base_bloc_module/base/bloc/base_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainBloc extends BaseBloc<MainEvent, MainState> {
  ContentUseCase contentUseCase;
  int couter = 0;
  final StreamController<void> toMain2 = StreamController();

  @factoryMethod
  MainBloc(this.contentUseCase) : super(MainState());

  @override
  void closeStream() {
    toMain2.close();
  }

  void testTap() {
    if (state.count! > 3) {
      emitter(state.copyWith(count: 0));
      toName.sink.add(CommonRoutes.MAIN2);
    } else {
      emitter(state.copyWith(count: (state.count ?? 0) + 1));
    }
  }

  void updateTestObject() {
    Test test = Test(
      name2: "name2 ${DateTime.now().millisecondsSinceEpoch}",
      name1: "name1 ${DateTime.now().millisecondsSinceEpoch}",
    );
    emitter(state.copyWith(test: test));
  }

  @override
  void initEvent(Object? event) {
    if (event is ClickMeEvent) return updateTestObject();
    if (event is ClickTestTapEvent) return testTap();
    if (event is ClickAddEvent) return addItemToList();
    if (event is ClickEditItemList) return editItem(event.index);
    if (event is ClickDeleteItemList) return deleteItemList(event.index);
  }

  void addItemToList() {
    List<String> list = List.of(state.listItem ?? []);
    list.add(DateTime.now().millisecondsSinceEpoch.toString());
    emitter(state.setList(list));
  }

  void editItem(int index) {
    List<String> list = List.of(state.listItem ?? []);
    list[index] = "edited ${DateTime.now().millisecondsSinceEpoch}";
    emitter(state.setList(list));
  }

  void deleteItemList(int index) {
    List<String> list = List.of(state.listItem ?? []);
    list.removeAt(index);
    emitter(state.setList(list));
  }
}
