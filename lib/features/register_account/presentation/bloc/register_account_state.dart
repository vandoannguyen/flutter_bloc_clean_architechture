import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_account_state.freezed.dart';

@Freezed(equal: true)
class RegisterAccountState extends BaseDataStateCubit with _$RegisterAccountState {
  RegisterAccountState._();

  factory RegisterAccountState() = _RegisterAccountState;
}

@freezed
class RegisterAccountEvent extends BaseCubitEvent with _$RegisterAccountEvent {
  RegisterAccountEvent._();

  const factory RegisterAccountEvent.navigateToLogin() = NavigateToLogin;
}
