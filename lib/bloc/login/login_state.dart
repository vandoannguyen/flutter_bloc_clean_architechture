import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_state.freezed.dart';

@Freezed(equal: true)
class LoginState extends BaseDataStateCubit with _$LoginState {
  LoginState._();

  factory LoginState() = _LoginState;
}

@freezed
class LoginEvent extends BaseCubitEvent with _$LoginEvent {
  LoginEvent._();

  factory LoginEvent.moveToHome() = MoveToHome;
}
