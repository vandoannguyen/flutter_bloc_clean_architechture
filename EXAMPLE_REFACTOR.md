# 📚 Refactor Example: Auth Feature

<!--
This document demonstrates how to refactor the Auth feature following the optimal
architecture pattern recommended for Clean Architecture with BLoC pattern.
It provides step-by-step guidance with code examples.
-->

This file illustrates how to refactor the Auth feature following the recommended optimal architecture pattern.

## Proposed Structure for Auth Feature:

<!--
Clean Architecture structure with three layers:
- data: External data sources and models
- domain: Business logic, entities, and use cases
- presentation: UI layer with BLoC and pages
-->

```
lib/features/auth/
├── data/
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart      # API calls
│   │   └── auth_local_datasource.dart        # Local storage
│   ├── models/
│   │   └── user_model.dart                  # JSON serializable
│   └── repositories/
│       └── auth_repository_impl.dart        # Repository implementation
│
├── domain/
│   ├── entities/
│   │   └── user_entity.dart                 # Pure Dart entity
│   ├── repositories/
│   │   └── auth_repository.dart             # Repository interface
│   └── usecases/
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       └── get_current_user_usecase.dart
│
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart
    │   └── auth_state.dart
    ├── pages/
    │   └── login_page.dart
    └── widgets/
        └── login_form.dart
```

## Step 1: Create Domain Entity (Pure Dart)

<!--
Domain entities are pure Dart classes with no dependencies on external frameworks.
They represent the core business objects.
-->

```dart
// lib/features/auth/domain/entities/user_entity.dart

/// User domain entity.
/// 
/// This is a pure Dart class representing a user in the domain layer.
/// It has no dependencies on external frameworks or data sources.
class UserEntity {
  final String id;
  final String email;
  final String? name;
  final String? avatarUrl;

  UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.avatarUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}
```

## Step 2: Create Data Model (JSON Serializable)

<!--
Data models are used for JSON serialization/deserialization.
They can be converted to domain entities and vice versa.
-->

```dart
// lib/features/auth/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User data model for JSON serialization.
/// 
/// This model is used for API communication and local storage.
/// It can be converted to/from UserEntity.
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelExtension on UserModel {
  /// Converts this model to a domain entity.
  /// 
  /// This is the bridge between data layer and domain layer.
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
    );
  }
}
```

## Step 3: Create Repository Interface (Domain Layer)

<!--
Repository interfaces are defined in the domain layer.
This ensures the domain layer doesn't depend on data layer implementations.
-->

```dart
// lib/features/auth/domain/repositories/auth_repository.dart
import '../../../../core/error/result.dart';
import '../entities/user_entity.dart';

/// Authentication repository interface.
/// 
/// This interface is defined in the domain layer, ensuring that
/// the domain doesn't depend on data layer implementations.
/// Implementations are provided by the data layer.
abstract class AuthRepository {
  /// Logs in a user with email and password.
  /// 
  /// Returns [Result<UserEntity>] containing the authenticated user or an error.
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });

  /// Logs out the current user.
  /// 
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> logout();

  /// Gets the currently authenticated user.
  /// 
  /// Returns [Result<UserEntity?>] containing the user if logged in, null otherwise.
  Future<Result<UserEntity?>> getCurrentUser();

  /// Saves authentication token.
  /// 
  /// [token] - The authentication token to save
  /// Returns [Result<void>] indicating success or failure.
  Future<Result<void>> saveToken(String token);
}
```

## Step 4: Implement Repository (Data Layer)

<!--
Repository implementation coordinates between remote and local data sources.
It handles error conversion and data transformation.
-->

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

/// Authentication repository implementation.
/// 
/// This class implements the AuthRepository interface and coordinates
/// between remote and local data sources.
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Call remote data source to authenticate user
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Cache user data locally for offline access
      await _localDataSource.cacheUser(userModel);

      // Convert model to entity and return success result
      return Result.success(userModel.toEntity());
    } on DioException catch (e) {
      // Handle network/API errors
      return Result.failure(_handleDioError(e));
    } catch (e) {
      // Handle unexpected errors
      return Result.failure(
        Failure.unknown(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      // Call remote API to logout
      await _remoteDataSource.logout();
      // Clear local user data
      await _localDataSource.clearUser();
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.unknown(message: 'Logout failed: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<UserEntity?>> getCurrentUser() async {
    try {
      // Get cached user from local storage
      final userModel = await _localDataSource.getCachedUser();
      if (userModel == null) {
        // No user cached, return null (not an error)
        return Result.success(null);
      }
      // Convert model to entity
      return Result.success(userModel.toEntity());
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to get cached user: ${e.toString()}'),
      );
    }
  }

  @override
  Future<Result<void>> saveToken(String token) async {
    try {
      await _localDataSource.saveToken(token);
      return Result.success(null);
    } catch (e) {
      return Result.failure(
        Failure.cache(message: 'Failed to save token: ${e.toString()}'),
      );
    }
  }

  /// Converts DioException to appropriate Failure type.
  /// 
  /// This method handles different types of network errors and converts
  /// them to domain-specific failure types.
  Failure _handleDioError(DioException error) {
    // Handle timeout errors
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return Failure.network(message: 'Connection timeout');
    }

    // Handle unauthorized errors
    if (error.response?.statusCode == 401) {
      return Failure.unauthorized(message: 'Invalid credentials');
    }

    // Handle server errors (5xx)
    if (error.response?.statusCode != null &&
        error.response!.statusCode! >= 500) {
      return Failure.server(
        message: 'Server error',
        statusCode: error.response!.statusCode,
      );
    }

    // Handle other network errors
    return Failure.network(message: error.message ?? 'Network error');
  }
}
```

## Step 5: Create Use Cases

<!--
Use cases encapsulate business logic and validation.
They orchestrate repository calls and handle business rules.
-->

```dart
// lib/features/auth/domain/usecases/login_usecase.dart
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/extensions/string_extensions.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Use case for user login.
/// 
/// This use case handles the business logic for user authentication,
/// including input validation and calling the repository.
@injectable
class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  /// Executes the login use case.
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  /// 
  /// Returns [Result<UserEntity>] containing either the authenticated user
  /// or a validation/authentication failure.
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Validate email is not empty
    if (email.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'Email cannot be empty'),
      );
    }

    // Validate email format
    if (!email.isValidEmail) {
      return Result.failure(
        Failure.validation(message: 'Invalid email format'),
      );
    }

    // Validate password is not empty
    if (password.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'Password cannot be empty'),
      );
    }

    // Validate password meets requirements
    if (!password.isValidPassword) {
      return Result.failure(
        Failure.validation(message: 'Password must be at least 8 characters'),
      );
    }

    // All validations passed, call repository
    return await _repository.login(email: email, password: password);
  }
}
```

## Step 6: Refactor BLoC

<!--
BLoC is simplified by delegating business logic to use cases.
It only handles state management and UI coordination.
-->

```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import 'auth_state.dart';

/// Authentication BLoC.
/// 
/// This BLoC manages authentication state and coordinates between
/// use cases and the UI layer.
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthBloc(
    this._loginUseCase,
    this._logoutUseCase,
    this._getCurrentUserUseCase,
  ) : super(AuthState.initial()) {
    // Check if user is already authenticated on initialization
    _checkAuthStatus();
  }

  /// Checks if user is already authenticated.
  /// 
  /// Called during BLoC initialization to restore authentication state.
  Future<void> _checkAuthStatus() async {
    final result = await _getCurrentUserUseCase();
    result.when(
      success: (user) {
        if (user != null) {
          // User is already logged in, update state
          emit(state.copyWith(
            status: AuthStatus.authenticated,
            user: user,
          ));
        }
      },
      failure: (_) {
        // Ignore error, user is not logged in
        // This is not an error state, just means no cached user
      },
    );
  }

  /// Handles user login.
  /// 
  /// [email] - User's email address
  /// [password] - User's password
  Future<void> login(String email, String password) async {
    // Update state to loading
    emit(state.copyWith(status: AuthStatus.loading));

    // Call use case to perform login
    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    // Handle result
    result.when(
      success: (user) {
        // Login successful, update state and navigate
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
        // Navigate to home screen (EventState - doesn't trigger rebuild)
        changeScreen(AppRoutes.home.routeName);
      },
      failure: (failure) {
        // Login failed, update state with error
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          errorMessage: failure.message,
        ));
        // Show error message (EventState - doesn't trigger rebuild)
        showMessage(
          failure.message,
          type: failure.isValidationError
              ? MessageType.waring
              : MessageType.error,
        );
      },
    );
  }

  /// Handles user logout.
  /// 
  /// Logs out the current user and clears authentication state.
  Future<void> logout() async {
    // Update state to loading
    emit(state.copyWith(status: AuthStatus.loading));

    // Call use case to perform logout
    final result = await _logoutUseCase();

    result.when(
      success: (_) {
        // Logout successful, clear user data
        emit(state.copyWith(
          status: AuthStatus.unauthenticated,
          user: null,
        ));
        // Navigate to login screen (EventState - doesn't trigger rebuild)
        changeScreen(AppRoutes.login.routeName);
      },
      failure: (failure) {
        // Logout failed, update state with error
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: failure.message,
        ));
        // Show error message (EventState - doesn't trigger rebuild)
        showMessage(failure.message, type: MessageType.error);
      },
    );
  }
}
```

## Step 7: Refactor State

<!--
State is defined using Freezed for immutability and type safety.
Status enum provides clear state machine transitions.
-->

```dart
// lib/features/auth/presentation/bloc/auth_state.dart
import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_state.freezed.dart';

/// Authentication state (DataState - triggers UI rebuild).
/// 
/// This state holds the authentication data and status.
/// Changes to this state will trigger UI rebuilds.
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  const AuthState._();

  factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserEntity? user,
    String? errorMessage,
  }) = _AuthState;
}

/// Authentication status enum for state machine.
/// 
/// This enum represents the different states in the authentication flow.
enum AuthStatus {
  initial,        // Initial state, no authentication attempt yet
  loading,        // Authentication in progress
  authenticated,  // User is authenticated
  unauthenticated, // User is not authenticated
  error,          // Authentication error occurred
}
```

## Step 8: Update View

<!--
View uses BlocBuilderDataState to only rebuild on DataState changes.
Events are handled separately without triggering rebuilds.
-->

```dart
// lib/features/auth/presentation/pages/login_page.dart
import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/extensions/build_context_extensions.dart';
import '../../../../core/utils/validators/validators.dart';
import '../../../../di/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';

/// Login page widget.
/// 
/// This page handles user login UI and coordinates with AuthBloc.
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

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocBuilderDataState<AuthBloc, AuthState>(
        builder: (context, state) {
          // Only rebuilds when AuthState (DataState) changes
          // Does NOT rebuild on EventState changes
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: LoginForm(
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: state.status == AuthStatus.loading,
                onLogin: _handleLogin,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Handles login button press.
  /// 
  /// Validates the form and calls the BLoC login method.
  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      bloc?.login(
        _emailController.text.trim(),
        _passwordController.text,
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
    // Handle events - does NOT trigger rebuild
    // Events like navigation, showing dialogs, etc. are handled here
    event.when(
      navigateToHome: () {
        // Navigation is handled by BaseViewCubitState
      },
      showError: (message) {
        // Error messages are handled by BaseViewCubitState
      },
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
```

## Benefits of This Refactoring Approach:

<!--
Key advantages of following this refactoring pattern:
-->

1. ✅ **Separation of Concerns**: Each layer has clear responsibilities
   - Domain layer: Business logic and entities
   - Data layer: Data sources and models
   - Presentation layer: UI and state management

2. ✅ **Testability**: Easy to test each layer independently
   - Use cases can be tested with mock repositories
   - Repositories can be tested with mock data sources
   - BLoC can be tested with mock use cases

3. ✅ **Reusability**: Use cases can be reused across different features
   - Login use case can be used in multiple places
   - Business logic is centralized and reusable

4. ✅ **Type Safety**: Result pattern helps handle errors safely
   - Compile-time error checking
   - Explicit error handling
   - No unexpected exceptions

5. ✅ **Maintainability**: Code is easier to read and maintain
   - Clear structure and organization
   - Single responsibility principle
   - Easy to locate and fix bugs

6. ✅ **Scalability**: Easy to add new features
   - Follow the same pattern for new features
   - Clear separation makes it easy to extend

## Next Steps:

<!--
Recommended steps to complete the refactoring:
-->

1. **Run code generation**: Execute `flutter pub run build_runner build` to generate Freezed code
   - This generates the `.freezed.dart` and `.g.dart` files

2. **Implement Data Sources**: Create remote and local data sources
   - `AuthRemoteDataSource`: API calls using Dio/Retrofit
   - `AuthLocalDataSource`: Local storage using SharedPreferences

3. **Write Unit Tests**: Create tests for Use Cases
   - Test validation logic
   - Test repository calls
   - Test error handling

4. **Write Widget Tests**: Create tests for UI components
   - Test form validation
   - Test state changes
   - Test user interactions

5. **Apply Pattern to Other Features**: Use this pattern for remaining features
   - Follow the same structure
   - Maintain consistency across features
