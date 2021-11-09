import 'dart:async';

import 'package:baese_flutter_bloc/module/domain/usecase/content_usecase.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_event.dart';
import 'package:baese_flutter_bloc/module/presenstation/bloc/main/main_view_sate.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:base_bloc_module/base/base_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class MainBloc extends BaseBloc<MainEvent, MainState> {
  ContentUseCase contentUseCase;
  int couter = 0;
  final StreamController<void> toMain2 = StreamController();

  @factoryMethod
  MainBloc(this.contentUseCase) : super(MainState());

  @override
  void initEventState() {
    on<MainEvent>((event, emit) {
      if (state.count! > 3) {
        emit(state.copyWith(count: 0));
        toName.sink.add(CommonRoutes.MAIN2);
      } else {
        emit(state.copyWith(count: (state.count ?? 0) + 1));
      }
    });
  }

  @override
  void closeStream() {
    toMain2.close();
  }
}
