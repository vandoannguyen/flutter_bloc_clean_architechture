import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Authentication state for data.
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  AuthState._();

  factory AuthState({
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}

/// Authentication events for UI side effects.
@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  AuthEvent._();

  const factory AuthEvent.navigateToHome() = NavigateToHome;
  const factory AuthEvent.navigateToLogin() = NavigateToLogin;
  const factory AuthEvent.showError(String message) = ShowError;
}
