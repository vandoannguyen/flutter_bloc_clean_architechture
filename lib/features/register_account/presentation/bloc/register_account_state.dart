import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_account_state.freezed.dart';

@Freezed(equal: true)
abstract class RegisterAccountState extends BaseDataStateCubit
    with _$RegisterAccountState {
  RegisterAccountState._();

  factory RegisterAccountState() = _RegisterAccountState;
}

@Freezed(equal: false)
abstract class RegisterAccountEvent extends BaseCubitEvent
    with _$RegisterAccountEvent {
  RegisterAccountEvent._();

  factory RegisterAccountEvent.navigateToLogin() = NavigateToLogin;
}
