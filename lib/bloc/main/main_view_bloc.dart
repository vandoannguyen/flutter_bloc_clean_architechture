import 'dart:async';
import 'package:base_flutter_bloc/bloc/main/main_view_event.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_flutter_bloc/model/request/login_request.dart';
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

  void testTap() {}

  void clickToLogin() {
    emit(OnChangeScreenEvent(AppRoutes.MAIN2.routeName));
  }

  Future<void> login() async {
    contentUseCase
        .login(LoginRequest("anonystick.com", "anonystick.com"))
        .then((value) {
      print(value);
    });
    return;
  }

  Future getUser() async {
    for (int i = 0; i < 3; i++) {
      contentUseCase.getData();
    }
    return;
  }
}
