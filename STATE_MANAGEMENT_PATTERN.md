# 🎯 State Management Pattern: DataState vs EventState

## 📋 Overview

Your project uses a **dual-state pattern** that separates:
- **DataState**: Holds screen data (triggers UI rebuild)
- **EventState**: Emits events like loading, messages, navigation (does NOT trigger UI rebuild)

This pattern provides excellent separation of concerns and prevents unnecessary rebuilds.

---

## 🏗️ Current Architecture

### 1. State Hierarchy

```
BaseStateCubit (abstract)
├── BaseDataStateCubit (for screen data)
└── BaseCubitEvent (for events)
    ├── OnLoadingEvent
    ├── OnMessageEvent
    ├── OnChangeScreenEvent
    └── Custom Events (LoginEvent, etc.)
```

### 2. How It Works

#### **BaseCubit** manages both states:
```dart
abstract class BaseCubit<STATE extends BaseStateCubit> extends Cubit<BaseStateCubit> {
  late STATE dataState; // Current data state
  
  // Emit DataState - triggers UI rebuild
  void updateData(STATE newState) {
    emit(newState);
    dataState = newState;
  }
  
  // Emit EventState - does NOT trigger UI rebuild
  void showLoading() => emit(OnLoadingEvent(true));
  void showMessage(String msg) => emit(OnMessageEvent(...));
  void changeScreen(String route) => emit(OnChangeScreenEvent(...));
}
```

#### **BlocBuilderDataState** only rebuilds on DataState:
```dart
BlocBuilderDataState<LoginBloc, LoginState>(
  builder: (context, state) {
    // Only rebuilds when LoginState (DataState) changes
    // Does NOT rebuild on EventState changes
  },
)
```

#### **BlocListener** handles EventState:
```dart
BlocListener<LoginBloc, BaseStateCubit>(
  listenWhen: (old, newState) => newState is BaseCubitEvent,
  listener: (context, state) {
    // Handle events: loading, message, navigation
    if (state is OnLoadingEvent) { /* show loading */ }
    if (state is OnMessageEvent) { /* show message */ }
    if (state is LoginEvent) { /* handle custom event */ }
  },
)
```

---

## ✅ Benefits of This Pattern

1. **Performance**: UI only rebuilds when data changes, not on events
2. **Separation of Concerns**: Clear distinction between data and events
3. **Type Safety**: Freezed ensures type-safe states and events
4. **Maintainability**: Easy to understand and maintain
5. **Testability**: Can test data and events separately

---

## 🚀 Recommended Improvements

### 1. Enhanced Event Types with Freezed

**Current:**
```dart
class OnLoadingEvent extends BaseCubitEvent {
  bool isLoading;
  OnLoadingEvent(this.isLoading);
}
```

**Improved:**
```dart
@freezed
class LoadingEvent extends BaseCubitEvent with _$LoadingEvent {
  const factory LoadingEvent.show() = ShowLoading;
  const factory LoadingEvent.hide() = HideLoading;
}

// Usage:
showLoading() => emit(const LoadingEvent.show());
hideLoading() => emit(const LoadingEvent.hide());
```

**Benefits:**
- Type-safe with pattern matching
- Immutable
- Better IDE support
- Easier to extend

---

### 2. Status-Based DataState Pattern

**Current:**
```dart
@Freezed(equal: true)
class LoginState extends BaseDataStateCubit with _$LoginState {
  factory LoginState() = _LoginState;
}
```

**Improved:**
```dart
@Freezed(equal: true)
class LoginState extends BaseDataStateCubit with _$LoginState {
  const LoginState._();
  
  factory LoginState({
    @Default(LoginStatus.initial) LoginStatus status,
    UserEntity? user,
    String? errorMessage,
  }) = _LoginState;
}

enum LoginStatus {
  initial,
  loading,
  success,
  error,
}
```

**Benefits:**
- Clear state machine
- Better error handling
- Easier to test
- More predictable state transitions

---

### 3. Enhanced Event Handling

**Current:**
```dart
void initEventViewModel(BuildContext context, LoginEvent state) {
  state.when(moveToHome: () {
    NavigatorUtils.instance.pushReplacementNamed(AppRoutes.home.routeName);
  });
}
```

**Improved with Result Pattern:**
```dart
void initEventViewModel(BuildContext context, LoginEvent state) {
  state.when(
    moveToHome: () {
      NavigatorUtils.instance.pushReplacementNamed(AppRoutes.home.routeName);
    },
    showError: (message) {
      context.showErrorSnackBar(message);
    },
    showSuccess: (message) {
      context.showSuccessSnackBar(message);
    },
  );
}
```

---

### 4. Better Loading State Management

**Current:**
```dart
void showLoading() => emit(OnLoadingEvent(true));
void hideLoading() => emit(OnLoadingEvent(false));
```

**Improved with Stack-based Loading:**
```dart
class BaseCubit<STATE extends BaseStateCubit> extends Cubit<BaseStateCubit> {
  final Set<String> _loadingOperations = {};
  
  void showLoading([String? operationId]) {
    if (operationId != null) {
      _loadingOperations.add(operationId);
    }
    emit(LoadingEvent.show());
  }
  
  void hideLoading([String? operationId]) {
    if (operationId != null) {
      _loadingOperations.remove(operationId);
      if (_loadingOperations.isNotEmpty) return;
    }
    emit(LoadingEvent.hide());
  }
  
  bool get isLoading => _loadingOperations.isNotEmpty;
}
```

**Benefits:**
- Handle multiple concurrent operations
- Prevent hiding loading if other operations are still running
- Better UX

---

### 5. Enhanced Message Events

**Current:**
```dart
void showMessage(String message, {MessageType type = MessageType.success}) {
  emit(OnMessageEvent(MessageModel(mess: message, messageType: type)));
}
```

**Improved:**
```dart
@freezed
class MessageEvent extends BaseCubitEvent with _$MessageEvent {
  const factory MessageEvent.show({
    required String message,
    required MessageType type,
    Duration? duration,
    VoidCallback? onDismiss,
  }) = ShowMessage;
  
  const factory MessageEvent.dismiss() = DismissMessage;
}

// Usage:
showMessage('Success!', type: MessageType.success);
showError('Error occurred', onDismiss: () => retry());
```

---

### 6. Navigation Events with Type Safety

**Current:**
```dart
void changeScreen(String routeName, dynamic data) {
  emit(OnChangeScreenEvent(routeName, data: data));
}
```

**Improved:**
```dart
@freezed
class NavigationEvent extends BaseCubitEvent with _$NavigationEvent {
  const factory NavigationEvent.push({
    required AppRoutes route,
    Object? arguments,
  }) = PushRoute;
  
  const factory NavigationEvent.pushReplacement({
    required AppRoutes route,
    Object? arguments,
  }) = PushReplacementRoute;
  
  const factory NavigationEvent.pop<T>([T? result]) = PopRoute;
  
  const factory NavigationEvent.popUntil({
    required AppRoutes route,
  }) = PopUntilRoute;
}

// Usage:
changeScreen(AppRoutes.home);
pushRoute(AppRoutes.profile, arguments: userId);
popRoute();
```

---

### 7. Combined State Pattern (Optional)

For complex screens, you might want to combine status with data:

```dart
@Freezed(equal: true)
class HomeState extends BaseDataStateCubit with _$HomeState {
  const HomeState._();
  
  factory HomeState({
    @Default(HomeStatus.initial) HomeStatus status,
    List<PostEntity>? posts,
    UserEntity? user,
    String? errorMessage,
    @Default(false) bool isLoadingMore,
    @Default(false) bool hasMore,
  }) = _HomeState;
}

enum HomeStatus {
  initial,
  loading,
  loaded,
  error,
  refreshing,
}
```

---

## 📝 Example: Refactored Login Feature

### State Definition:
```dart
// lib/features/auth/presentation/bloc/auth_state.dart
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  const AuthState._();
  
  factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserEntity? user,
    String? errorMessage,
  }) = _AuthState;
}

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const AuthEvent._();
  
  const factory AuthEvent.navigateToHome() = NavigateToHome;
  const factory AuthEvent.navigateToRegister() = NavigateToRegister;
  const factory AuthEvent.showError(String message) = ShowAuthError;
}
```

### BLoC Implementation:
```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  
  AuthBloc(this._loginUseCase) : super(AuthState.initial());
  
  Future<void> login(String email, String password) async {
    // Update data state - triggers UI rebuild
    emit(state.copyWith(status: AuthStatus.loading));
    
    final result = await _loginUseCase(email: email, password: password);
    
    result.when(
      success: (user) {
        // Update data state
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
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
}
```

### View Implementation:
```dart
// lib/features/auth/presentation/pages/login_page.dart
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseViewCubitState<
    AuthBloc, AuthState, AuthEvent, LoginPage> {
  
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      body: BlocBuilderDataState<AuthBloc, AuthState>(
        builder: (context, state) {
          // Only rebuilds when AuthState (DataState) changes
          return Column(
            children: [
              if (state.status == AuthStatus.loading)
                const CircularProgressIndicator(),
              if (state.status == AuthStatus.error)
                Text(state.errorMessage ?? 'Error'),
              // ... rest of UI
            ],
          );
        },
      ),
    );
  }
  
  @override
  AuthBloc initBloc() => getIt<AuthBloc>();
  
  @override
  void initData() {
    // Load initial data
  }
  
  @override
  void initEventViewModel(BuildContext context, AuthEvent event) {
    // Handle events - does NOT rebuild UI
    event.when(
      navigateToHome: () {
        NavigatorUtils.instance.pushReplacementNamed(AppRoutes.home.routeName);
      },
      navigateToRegister: () {
        NavigatorUtils.instance.pushNamed(AppRoutes.register.routeName);
      },
      showError: (message) {
        context.showErrorSnackBar(message);
      },
    );
  }
}
```

---

## 🎯 Best Practices

### 1. **When to use DataState:**
- ✅ Data that affects UI rendering
- ✅ Lists, user info, form data
- ✅ Status that changes UI appearance
- ✅ Any state that should trigger rebuild

### 2. **When to use EventState:**
- ✅ One-time actions (navigation, show dialog)
- ✅ Side effects (show message, show loading)
- ✅ Actions that don't affect current UI
- ✅ Commands/instructions to the UI layer

### 3. **State Updates:**
```dart
// ✅ Good: Update data state
emit(state.copyWith(posts: newPosts));

// ✅ Good: Emit event
emit(AuthEvent.navigateToHome());

// ❌ Bad: Don't mix them
emit(state.copyWith(posts: newPosts));
emit(OnLoadingEvent(true)); // Should be separate
```

### 4. **Event Handling:**
```dart
// ✅ Good: Handle in listener
BlocListener<AuthBloc, BaseStateCubit>(
  listenWhen: (old, newState) => newState is AuthEvent,
  listener: (context, state) {
    if (state is AuthEvent) {
      // Handle event
    }
  },
)

// ❌ Bad: Don't handle in builder
BlocBuilder<AuthBloc, AuthState>(
  builder: (context, state) {
    // Don't handle events here!
  },
)
```

---

## 🔧 Migration Guide

### Step 1: Update Base Events to Freezed

```dart
// base_bloc_module/lib/base/cubit/base_cubit_event.dart
@freezed
class LoadingEvent extends BaseCubitEvent with _$LoadingEvent {
  const factory LoadingEvent.show() = ShowLoading;
  const factory LoadingEvent.hide() = HideLoading;
}

@freezed
class MessageEvent extends BaseCubitEvent with _$MessageEvent {
  const factory MessageEvent.show({
    required String message,
    required MessageType type,
  }) = ShowMessage;
}
```

### Step 2: Update BaseCubit Methods

```dart
void showLoading() => emit(const LoadingEvent.show());
void hideLoading() => emit(const LoadingEvent.hide());
```

### Step 3: Update View Listeners

```dart
BlocListener<AuthBloc, BaseStateCubit>(
  listenWhen: (old, newState) => newState is BaseCubitEvent,
  listener: (context, state) {
    state.maybeWhen(
      // Handle LoadingEvent
      showLoading: () => showLoading(context),
      hideLoading: () => hideLoading(context),
      // Handle MessageEvent
      showMessage: (msg, type) => showMessage(context, msg, type),
      // Handle custom events
      orElse: () {
        if (state is AuthEvent) {
          initEventViewModel(context, state as AuthEvent);
        }
      },
    );
  },
)
```

---

## 📊 Comparison: Before vs After

| Aspect | Current | Improved |
|--------|---------|----------|
| Type Safety | ✅ Good | ✅✅ Excellent (Freezed) |
| Immutability | ⚠️ Partial | ✅✅ Full (Freezed) |
| Pattern Matching | ❌ No | ✅✅ Yes |
| Loading Management | ⚠️ Basic | ✅✅ Stack-based |
| Navigation | ⚠️ String-based | ✅✅ Type-safe |
| Error Handling | ⚠️ Basic | ✅✅ With Result pattern |

---

## 🎓 Summary

Your **DataState/EventState pattern** is excellent! The improvements suggested focus on:

1. **Type Safety**: Using Freezed for all states/events
2. **Better Organization**: Status-based data states
3. **Enhanced Features**: Stack-based loading, type-safe navigation
4. **Best Practices**: Clear guidelines for when to use each pattern

This pattern provides:
- ✅ Better performance (fewer rebuilds)
- ✅ Clear separation of concerns
- ✅ Easier testing
- ✅ Better maintainability

Keep using this pattern - it's one of the best approaches for Flutter BLoC state management! 🚀
