import 'dart:async';

import 'package:baese_flutter_bloc/module/domain/entity/content/content_model.dart';
import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
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
  void initEventState() {}

  @override
  void closeStream() {
    toMain2.close();
  }

  void testTap() {
    ContentModel? user = state.user?.copyWith();
    if (user == null) {
      user = ContentModel(
          a: "a${DateTime.now().millisecondsSinceEpoch}",
          b: "b${DateTime.now().millisecondsSinceEpoch}");
    } else {
      user = user.copyWith(
          a: "a${DateTime.now().millisecondsSinceEpoch}",
          b: "b${DateTime.now().millisecondsSinceEpoch}");
    }
    print(user.toString());
    emit(state.copyWith(user: user));
    if (state.count! > 3) {
      emit(state.copyWith(count: 0));
      toMain2.sink.add(null);
    } else {
      emit(state.copyWith(count: (state.count ?? 0) + 1));
    }
  }
}
