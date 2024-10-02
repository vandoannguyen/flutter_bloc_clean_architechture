import 'package:base_bloc_module/index.dart';
import 'package:base_flutter_bloc/bloc/login/login_state.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginBloc extends BaseCubit<LoginState> {
  @factoryMethod
  LoginBloc() : super(LoginState());

  void handleLogin() {
    // do some logic
    emit(
      LoginEvent.moveToHome(),
    );
  }
}
