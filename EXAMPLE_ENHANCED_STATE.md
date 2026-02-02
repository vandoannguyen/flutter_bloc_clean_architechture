# 📚 Example: Enhanced State Management Implementation

This document shows how to implement the improved state management pattern with your existing DataState/EventState architecture.

## 🎯 Example: Auth Feature with Enhanced States

### 1. Enhanced State Definition

```dart
// lib/features/auth/presentation/bloc/auth_state.dart
import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Auth data state - holds screen data and triggers UI rebuild
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  const AuthState._();

  factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserEntity? user,
    String? errorMessage,
    @Default(false) bool isRememberMe,
  }) = _AuthState;

  /// Convenience getters for status checking
  bool get isInitial => status == AuthStatus.initial;
  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isError => status == AuthStatus.error;
}

/// Auth status enum for state machine
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

/// Auth events - do NOT trigger UI rebuild
@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const AuthEvent._();

  /// Navigate to home screen
  const factory AuthEvent.navigateToHome() = NavigateToHome;

  /// Navigate to register screen
  const factory AuthEvent.navigateToRegister() = NavigateToRegister;

  /// Navigate to forgot password screen
  const factory AuthEvent.navigateToForgotPassword() = NavigateToForgotPassword;

  /// Show error message
  const factory AuthEvent.showError(String message) = ShowAuthError;

  /// Show success message
  const factory AuthEvent.showSuccess(String message) = ShowAuthSuccess;

  /// Show dialog
  const factory AuthEvent.showDialog({
    required String title,
    required String message,
    VoidCallback? onConfirm,
  }) = ShowAuthDialog;
}
```

### 2. Enhanced BLoC Implementation

```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/bloc/enhanced_base_cubit.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

@injectable
class AuthBloc extends EnhancedBaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    final result = await _getCurrentUserUseCase();
    result.when(
      success: (user) {
        if (user != null) {
          // Update data state - triggers UI rebuild
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          ));
        }
      },
      failure: (_) {
        // User not logged in, keep initial state
      },
    );
  }

  /// Login with email and password
  Future<void> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Update data state - triggers UI rebuild
    emit(state.copyWith(
      status: AuthStatus.loading,
      errorMessage: null,
      isRememberMe: rememberMe,
    ));

    // Execute login with automatic loading management
    final result = await executeWithLoading(
      () => _loginUseCase(email: email, password: password),
      operationId: 'login',
    );

    result.when(
      success: (user) {
        // Update data state
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          errorMessage: null,
        ));
        // Emit event - does NOT trigger rebuild
        emit(const AuthEvent.navigateToHome());
      },
      failure: (failure) {
        // Update data state
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
        // Emit event
        emit(AuthEvent.showError(failure.message));
      },
    );
  }

  /// Logout current user
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await executeWithLoading(
      () => _logoutUseCase(),
      operationId: 'logout',
    );

    result.when(
      success: (_) {
        // Update data state
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
        ));
        // Emit event
        emit(const AuthEvent.navigateToHome());
      },
      failure: (failure) {
        // Update data state
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
        // Emit event
        emit(AuthEvent.showError(failure.message));
      },
    );
  }

  /// Clear error state
  void clearError() {
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      errorMessage: null,
    ));
  }
}
```

### 3. Enhanced View Implementation

```dart
// lib/features/auth/presentation/pages/login_page.dart
import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/build_context_extensions.dart';
import '../../../../core/utils/validators/validators.dart';
import '../../../../di/injection_container.dart';
import '../../../../routes/index.dart';
import '../../../../utils/navigate_utils.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState
    extends BaseViewCubitState<AuthBloc, AuthState, AuthEvent, LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SafeArea(
        child: BlocBuilderDataState<AuthBloc, AuthState>(
          builder: (context, state) {
            // Only rebuilds when AuthState (DataState) changes
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Show error message if any
                    if (state.isError && state.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: context.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: context.colorScheme.error,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                state.errorMessage!,
                                style: TextStyle(
                                  color: context.colorScheme.onErrorContainer,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => bloc?.clearError(),
                            ),
                          ],
                        ),
                      ),

                    // Login form
                    LoginForm(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      rememberMe: _rememberMe,
                      onRememberMeChanged: (value) {
                        setState(() => _rememberMe = value);
                      },
                      onLogin: _handleLogin,
                      isLoading: state.isLoading,
                    ),

                    const SizedBox(height: 16),

                    // Register link
                    TextButton(
                      onPressed: () {
                        NavigatorUtils.instance.pushNamed(
                          AppRoutes.register.routeName,
                        );
                      },
                      child: const Text('Don\'t have an account? Register'),
                    ),

                    // Forgot password link
                    TextButton(
                      onPressed: () {
                        NavigatorUtils.instance.pushNamed(
                          AppRoutes.forgotPassword.routeName,
                        );
                      },
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      bloc?.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        rememberMe: _rememberMe,
      );
    }
  }

  @override
  AuthBloc initBloc() {
    return getIt<AuthBloc>();
  }

  @override
  void initData() {
    // Load initial data if needed
    // For example: check if user is already logged in
  }

  @override
  void initEventViewModel(BuildContext context, AuthEvent event) {
    // Handle events - does NOT trigger UI rebuild
    event.when(
      navigateToHome: () {
        NavigatorUtils.instance.pushReplacementNamed(
          AppRoutes.home.routeName,
        );
      },
      navigateToRegister: () {
        NavigatorUtils.instance.pushNamed(
          AppRoutes.register.routeName,
        );
      },
      navigateToForgotPassword: () {
        NavigatorUtils.instance.pushNamed(
          AppRoutes.forgotPassword.routeName,
        );
      },
      showError: (message) {
        context.showErrorSnackBar(message);
      },
      showSuccess: (message) {
        context.showSuccessSnackBar(message);
      },
      showDialog: (title, message, onConfirm) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  onConfirm?.call();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

### 4. Usage Example with Multiple Loading Operations

```dart
// Example: Loading multiple data sources concurrently
Future<void> loadDashboardData() async {
  // Show loading for the entire operation
  showLoading('dashboard');
  
  try {
    // Load multiple data sources concurrently
    final results = await executeAllWithLoading([
      () => _loadUserProfile(),
      () => _loadNotifications(),
      () => _loadRecentActivity(),
    ]);
    
    // Update state with all data
    emit(state.copyWith(
      userProfile: results[0],
      notifications: results[1],
      recentActivity: results[2],
      status: DashboardStatus.loaded,
    ));
  } catch (e) {
    emit(state.copyWith(
      status: DashboardStatus.error,
      errorMessage: e.toString(),
    ));
  } finally {
    // Hide loading when all operations complete
    hideLoading('dashboard');
  }
}
```

## 🎯 Key Benefits

1. **Clear Separation**: DataState vs EventState
2. **Performance**: UI only rebuilds on data changes
3. **Type Safety**: Freezed ensures type-safe states/events
4. **Better Loading**: Stack-based loading management
5. **Status Pattern**: Clear state machine with enums
6. **Easy Testing**: Can test data and events separately

## 📝 Best Practices Demonstrated

1. ✅ DataState holds screen data (triggers rebuild)
2. ✅ EventState for one-time actions (no rebuild)
3. ✅ Status enum for clear state machine
4. ✅ Result pattern for error handling
5. ✅ Enhanced loading management
6. ✅ Type-safe navigation events
