import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

/// Authentication BLoC for managing auth state and events.
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(const AuthState()) {
    _checkAuthStatus();
  }

  /// Checks if user is already authenticated.
  Future<void> _checkAuthStatus() async {
    final result = await _getCurrentUserUseCase();
    result.when(
      success: (user) {
        if (user != null) {
          emit(state.copyWith(
            user: user,
            isAuthenticated: true,
          ));
        }
      },
      failure: (_) {
        // User not logged in
      },
    );
  }

  /// Logs in a user.
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  Future<void> login(String email, String password) async {
    showLoading();

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    hideLoading();

    result.when(
      success: (user) {
        emit(state.copyWith(
          user: user,
          isAuthenticated: true,
        ));
        emit(const AuthEvent.navigateToHome());
      },
      failure: (failure) {
        emit(AuthEvent.showError(failure.message));
        showMessage(
          failure.message,
          type: failure.isValidationError
              ? MessageType.waring
              : MessageType.error,
        );
      },
    );
  }

  /// Logs out the current user.
  Future<void> logout() async {
    showLoading();

    final result = await _logoutUseCase();

    hideLoading();

    result.when(
      success: (_) {
        emit(const AuthState());
        emit(const AuthEvent.navigateToLogin());
      },
      failure: (failure) {
        emit(AuthEvent.showError(failure.message));
        showMessage(failure.message, type: MessageType.error);
      },
    );
  }
}
