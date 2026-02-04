# Base BLoC Module

Base module providing base classes and utilities for the BLoC pattern in Clean Architecture.

## 📦 Purpose

This module provides base classes and utilities to:
- **Separate Data State and Event State** - Reduce unnecessary rebuilds
- **Automatically manage BLoC lifecycle** - Reduce boilerplate
- **Handle loading and messages** - Built-in loading dialog and message display
- **Navigation utilities** - Navigation without BuildContext

## 🏗️ Module Structure

```
base_bloc_module/
├── base/
│   ├── cubit/
│   │   ├── base_cubit.dart              # Base class for all Cubit/Bloc
│   │   ├── base_data_state_cubit.dart   # Base class for Data State
│   │   ├── base_state_cubit.dart        # Base class for State Cubit
│   │   └── base_cubit_event.dart        # Base class for Event State
│   └── bloc_builder/
│       └── bloc_builder_data_state.dart  # Widget rebuilds only on Data State change
├── views/
│   ├── base_view_cubit.dart            # Base StatelessWidget with BLoC
│   ├── base_view_cubit_state.dart      # Base State for StatefulWidget with BLoC
│   └── widgets/
│       └── loading_widget.dart          # Loading widget
├── common/
│   └── base_bloc_config.dart           # Configuration for loading/messages
└── models/
    └── message_model.dart              # Model for messages
```

## 🎯 Main Components

### 1. BaseCubit

Base class for all Cubit/Bloc, providing:
- `showLoading()` / `hideLoading()` - Show/hide loading dialog
- `showMessage()` - Show message (success/error/warning)
- `dataState` - Getter to access data state
- `emit()` - Override to emit both Data State and Event State

```dart
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc(this._loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    showLoading();
    
    final result = await _loginUseCase(email: email, password: password);
    
    hideLoading();
    
    result.when(
      success: (user) {
        emit(dataState.copyWith(user: user)); // Update data state
        emit(const AuthEvent.navigateToHome()); // Emit event
      },
      failure: (failure) {
        showMessage(failure.message, type: MessageType.error);
      },
    );
  }
}
```

### 2. BaseDataStateCubit

Base class for Data State - State holds only data, no events.

```dart
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  AuthState._();

  factory AuthState({
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}
```

### 3. BaseCubitEvent

Base class for Event State - One-time events for navigation, dialogs, etc.

```dart
@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  AuthEvent._();

  const factory AuthEvent.navigateToHome() = NavigateToHome;
  const factory AuthEvent.showError(String message) = ShowError;
}
```

### 4. BlocBuilderDataState

Widget rebuilds only when Data State changes, ignoring Event State.

```dart
BlocBuilderDataState<AuthBloc, AuthState>(
  bloc: bloc,
  builder: (context, state) {
    return Text("User: ${state.user?.email}");
  },
)
```

### 5. BaseViewCubit

Base StatelessWidget that automatically manages BLoC lifecycle.

```dart
class LoginView extends BaseViewCubit<AuthBloc, AuthState> {
  LoginView({Key? key}) : super(key: key);

  @override
  Widget buildWidget(BuildContext context) {
    return BlocBuilderDataState<AuthBloc, AuthState>(
      bloc: bloc,
      builder: (context, state) => Text("${state.user?.email}"),
    );
  }

  @override
  AuthBloc initBloc() {
    return getIt<AuthBloc>();
  }

  @override
  void initData() {
    // Load initial data
  }

  @override
  void initEventViewModel(BuildContext context, AuthEvent state) {
    state.when(
      navigateToHome: () => NavigatorUtils.pushReplacementNamed('/home'),
      showError: (message) => showMessage(message),
    );
  }
}
```

### 6. BaseViewCubitState

Base State for StatefulWidget with BLoC.

```dart
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseViewCubitState<AuthBloc, AuthState, AuthEvent, LoginScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: BlocBuilderDataState<AuthBloc, AuthState>(
        builder: (context, state) => Container(),
      ),
    );
  }

  @override
  AuthBloc initBloc() => getIt<AuthBloc>();

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, AuthEvent state) {
    state.when(
      navigateToHome: () {},
      showError: (message) {},
    );
  }
}
```

## 🔧 Configuration

### Setup Loading Widget

In `main.dart`:

```dart
import 'package:base_bloc_module/common/base_bloc_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  BaseBlocConfig.instance.configLoadingWidget(() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  });
  
  runApp(const MyApp());
}
```

### Setup Message Widget

```dart
BaseBlocConfig.instance.configMessageWidget((messageModel) {
  return Text(
    messageModel.mess,
    style: TextStyle(
      color: messageModel.messageType == MessageType.waring
          ? Colors.orange
          : messageModel.messageType == MessageType.error
              ? Colors.red
              : Colors.green,
    ),
  );
});
```

## 📐 Integration with Clean Architecture

### In Presentation Layer

This module is used in the **Presentation Layer** of Clean Architecture:

```
lib/features/{feature}/presentation/
├── bloc/
│   ├── {feature}_bloc.dart        # Extends BaseCubit
│   └── {feature}_state.dart      # Extends BaseDataStateCubit & BaseCubitEvent
└── pages/
    └── {feature}_screen.dart      # Extends BaseViewCubit or BaseViewCubitState
```

### Complete Example

#### 1. Domain Layer (Pure Dart)

```dart
// features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  // Pure Dart, no dependencies
}

// features/auth/domain/usecases/login_usecase.dart
@injectable
class LoginUseCase {
  final AuthRepository _repository;
  
  Future<Result<UserEntity>> call({required String email, required String password}) {
    // Business logic
  }
}
```

#### 2. Data Layer

```dart
// features/auth/data/models/user_model.dart
@JsonSerializable()
class UserModel {
  final String id;
  final String email;
  // JSON serializable
}

// features/auth/data/repositories/auth_repository_impl.dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // Implementation
}
```

#### 3. Presentation Layer (Using Base BLoC Module)

```dart
// features/auth/presentation/bloc/auth_state.dart
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  factory AuthState({
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}

@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const factory AuthEvent.navigateToHome() = NavigateToHome;
}

// features/auth/presentation/bloc/auth_bloc.dart
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc(this._loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    showLoading();
    final result = await _loginUseCase(email: email, password: password);
    hideLoading();
    
    result.when(
      success: (user) {
        emit(dataState.copyWith(user: user));
        emit(const AuthEvent.navigateToHome());
      },
      failure: (failure) {
        showMessage(failure.message, type: MessageType.error);
      },
    );
  }
}

// features/auth/presentation/pages/login_screen.dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseViewCubitState<AuthBloc, AuthState, AuthEvent, LoginScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: BlocBuilderDataState<AuthBloc, AuthState>(
        bloc: bloc,
        builder: (context, state) {
          return Column(
            children: [
              Text(state.user?.email ?? 'Not logged in'),
              ElevatedButton(
                onPressed: () => bloc?.login('email', 'password'),
                child: const Text('Login'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  AuthBloc initBloc() => getIt<AuthBloc>();

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, AuthEvent event) {
    event.when(
      navigateToHome: () => NavigatorUtils.pushReplacementNamed('/home'),
      showError: (message) => showMessage(message),
    );
  }
}
```

## 🎨 Benefits

### 1. Separate Data State and Event State

- **Data State**: Rebuild UI only when data changes
- **Event State**: One-time events do not trigger rebuild

### 2. Less Boilerplate

- Automatic BLoC lifecycle management
- Automatic BLoC dispose
- Automatic event listening

### 3. Built-in Integration

- Loading dialog
- Message display
- Navigation utilities

### 4. Type Safety

- Type-safe state management
- Compile-time checks

## 📚 Best Practices

### 1. Use BlocBuilderDataState

Always use `BlocBuilderDataState` instead of `BlocBuilder` to avoid unnecessary rebuilds:

```dart
// ✅ Good
BlocBuilderDataState<AuthBloc, AuthState>(
  bloc: bloc,
  builder: (context, state) => Text(state.user?.email ?? ''),
)

// ❌ Bad - rebuilds when Event State changes too
BlocBuilder<AuthBloc, AuthState>(
  bloc: bloc,
  builder: (context, state) => Text(state.user?.email ?? ''),
)
```

### 2. Separate Data State and Event State

```dart
// ✅ Good - Clear separation
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  factory AuthState({UserEntity? user}) = _AuthState;
}

@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const factory AuthEvent.navigateToHome() = NavigateToHome;
}

// ❌ Bad - Mixing data and events
class AuthState {
  UserEntity? user;
  bool shouldNavigate; // Event in Data State
}
```

### 3. Use Use Cases in BLoC

```dart
// ✅ Good - BLoC only coordinates, no business logic
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  
  Future<void> login(String email, String password) async {
    final result = await _loginUseCase(email: email, password: password);
    // Handle result
  }
}

// ❌ Bad - Business logic in BLoC
class AuthBloc extends BaseCubit<AuthState> {
  Future<void> login(String email, String password) async {
    // Business validation here - should be in Use Case
    if (email.isEmpty) return;
    // ...
  }
}
```

## 🔗 Links

- [Main Project README](../README.md) - Project overview
- [Clean Architecture Layers](../CLEAN_ARCHITECTURE_LAYERS.md) - Layer details
- [Form Validation Guide](../FORM_VALIDATION_GUIDE.md) - Validation guide

## 📝 License

This module is part of the Flutter BLoC Clean Architecture project.
