import 'dart:async';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:injectable/injectable.dart';

import '../../model/entity/content/content_model.dart';
import '../../model/repository/content/content_repository.dart';
import '../../routes/routes.dart';
import 'main_view_sate.dart';

@injectable
class MainBloc extends BaseCubit<MainState> {
  ContentRepository contentUseCase;
  int couter = 0;

  @factoryMethod
  MainBloc(this.contentUseCase) : super(MainState());

  void testTap() {
    ContentModel? user = dataState.user?.copyWith();
    if (user == null) {
      user = ContentModel(
          a: "a${DateTime.now().millisecondsSinceEpoch}",
          b: "b${DateTime.now().millisecondsSinceEpoch}");
    } else {
      user = user.copyWith(
          a: "a${DateTime.now().millisecondsSinceEpoch}",
          b: "b${DateTime.now().millisecondsSinceEpoch}");
    }
    emit(dataState.copyWith(user: user));
    if (dataState.count! > 3) {
      emit(dataState.copyWith(count: 0));
      clickToLogin();
    } else {
      emit(dataState.copyWith(count: (dataState.count ?? 0) + 1));
    }
  }

  void clickToLogin() {
    emit(OnChangeScreenEvent(AppRoutes.MAIN2));
  }
}
