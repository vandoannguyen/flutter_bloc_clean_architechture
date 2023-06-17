import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../model/repository/content/content_repository.dart';
import '../../utils/auth_utils.dart';

part 'main2_event.dart';

part 'main2_state.dart';

@injectable
class Main2Bloc extends BaseCubit<Main2State> {
  ContentRepository contentUseCase;

  @factoryMethod
  Main2Bloc(this.contentUseCase) : super(Main2State());

  Future<void> loginGoogle() async {
    AuthUtils.instance.loginGoogle();
  }

  void loginFacebook() {
    AuthUtils.instance.loginFacebook();
  }

  void loginApple() {
    AuthUtils.instance.loginApple();
  }
}
