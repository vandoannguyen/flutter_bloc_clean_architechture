import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Authentication state for data.
@Freezed(equal: true)
abstract class AuthState extends BaseDataStateCubit with _$AuthState {
  AuthState._();

  factory AuthState({
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}

/// Authentication events for UI side effects.
@Freezed(equal: false)
abstract class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  AuthEvent._();

   factory AuthEvent.navigateToHome() = _NavigateToHome;
   factory AuthEvent.navigateToLogin() = _NavigateToLogin;
   factory AuthEvent.showError(String message) = _ShowError;
}
