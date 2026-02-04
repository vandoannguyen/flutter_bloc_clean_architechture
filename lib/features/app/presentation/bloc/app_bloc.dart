import 'dart:async';

import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:injectable/injectable.dart';
import 'app_state.dart';

@singleton
class AppBloc extends BaseCubit<AppState> {
  final StreamController<void> toMain2 = StreamController();

  @factoryMethod
  AppBloc() : super(AppState());

  void testTap() {}

  void handleLoading() {
    showLoading();
  }

  @override
  Future<void> close() {
    toMain2.close();
    return super.close();
  }
}
