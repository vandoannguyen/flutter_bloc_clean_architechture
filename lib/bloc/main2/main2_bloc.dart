import 'package:baese_flutter_bloc/bloc/main2/main2_state.dart';
import 'package:base_bloc_module/base/cubit/base_cubit.dart';
import 'package:injectable/injectable.dart';
import '../../model/repository/content/content_repository.dart';
import '../../utils/auth_utils.dart';

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

  void loadData() {}
}
