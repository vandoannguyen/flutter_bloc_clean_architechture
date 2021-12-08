import 'dart:async';

import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainBloc extends BaseCubit<MainState> {
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
      emit(state.copyWith(count: 0));
      toName.sink.add(CommonRoutes.MAIN2);
    } else {
      emit(state.copyWith(count: (state.count ?? 0) + 1));
    }
  }

  void clickEdit(int index) {
    List<String> list = List.of(state.listItem ?? []);
    list[index] = "edit ${DateTime.now().millisecondsSinceEpoch}";
    emit(state.copyWith(listItem: list));
  }

  void deleteItem(int index) {
    List<String> list = List.of(state.listItem ?? []);
    list.removeAt(index);
    emit(state.copyWith(listItem: list));
  }

  void addItem() {
    List<String> list = List.of(state.listItem ?? []);
    list.add("${DateTime.now().millisecondsSinceEpoch}");
    emit(state.copyWith(listItem: list));
  }
}
