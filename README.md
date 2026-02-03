# Flutter BLoC Clean Architecture

A Flutter project implementing Clean Architecture with BLoC pattern for state management.

## 📦 Packages

- **[Bloc Pattern: flutter_bloc](https://pub.dev/packages/flutter_bloc)** - State management
- **[Dependency Injection: get_it + injectable](https://pub.dev/packages/get_it)** - DI framework
- **[Network: dio + retrofit](https://pub.dev/packages/dio)** - HTTP client
- **[Localization: flutter_localizations](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)** - Multi-language support
- **[Flavors: prod, dev, uat](https://docs.flutter.dev/deployment/flavors)** - Environment configuration
- **[Code Generation: Freezed](https://pub.dev/packages/freezed)** - Immutable classes and unions
- **[JSON Serialization: json_serializable](https://pub.dev/packages/json_serializable)** - Model serialization

## 🏗️ Project Structure

This project follows **Clean Architecture** principles with **feature-based** organization:

```
lib/
├── core/                   # Core infrastructure (shared across features)
│   ├── error/             # Error handling (Result, Failure)
│   ├── network/           # Network configuration (DioClient, etc.)
│   ├── di/                # Dependency injection setup
│   ├── utils/             # Core utilities
│   ├── constants/         # App constants
│   └── mappers/           # Base mapper interfaces
│
├── features/               # Feature modules (Clean Architecture)
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer
│   │   │   ├── datasources/  # Remote & Local data sources
│   │   │   ├── models/       # Data models (JSON serializable)
│   │   │   ├── mappers/      # Model-Entity mappers
│   │   │   └── repositories/ # Repository implementations
│   │   ├── domain/        # Domain layer (pure business logic)
│   │   │   ├── entities/     # Domain entities (pure Dart)
│   │   │   ├── repositories/ # Repository interfaces
│   │   │   └── usecases/     # Use cases (business logic)
│   │   └── presentation/  # Presentation layer (UI)
│   │       ├── bloc/         # BLoC/Cubit
│   │       ├── pages/        # Screens
│   │       └── widgets/       # Feature-specific widgets
│   │
│   └── home/              # Home feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/                 # Shared resources
    ├── routes/            # Routing configuration
    ├── theme/             # Theme configuration
    ├── widgets/           # Common widgets
    └── utils/              # Shared utilities
```

## 🎯 Clean Architecture Layers

### Domain Layer (Innermost)
- **Pure Dart** - No framework dependencies
- **Entities**: Pure Dart classes representing business objects
- **Repository Interfaces**: Abstract classes defining data contracts
- **Use Cases**: Business logic encapsulated in single-purpose classes

### Data Layer
- **Models**: JSON serializable classes (using Freezed/json_serializable)
- **Data Sources**: API calls (Remote) and local storage (Local)
- **Repository Implementations**: Implement domain repository interfaces
- **Mappers**: Convert between Models and Entities

### Presentation Layer
- **BLoC/Cubit**: State management using flutter_bloc
- **Pages**: UI screens
- **Widgets**: Feature-specific UI components

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.8.0)
- Dart SDK

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Generate code (Freezed, json_serializable, injectable):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

### Generate Files

Watch for changes and auto-generate:
```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

Build once:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📱 Flavors

The project supports multiple environments:

- **dev** - Development environment
- **uat** - User Acceptance Testing environment
- **prod** - Production environment

### Run with flavor:

```bash
flutter run --dart-define=FLUTTER_APP_FLAVOR=dev
```

### Build APK:

```bash
flutter build apk --flavor dev -t lib/main.dart
```

## 🎨 Usage Examples

### BLoC Pattern

#### Using BlocBuilderDataState

Instead of regular `BlocBuilder`, use `BlocBuilderDataState` to only rebuild on data state changes:

```dart
BlocBuilderDataState<AuthBloc, AuthState>(
  bloc: bloc,
  builder: (context, state) {
    return Text("User: ${state.user?.email}");
  },
)
```

#### Using BaseViewCubit

Extend `BaseViewCubit` for automatic BLoC setup:

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

#### Using StatefulWidget with BaseViewCubitState

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
  void initEventViewModel(BuildContext context, AuthEvent state) {}
}
```

### State Management

#### Data State vs Event State

The project uses a custom pattern separating **Data State** (triggers UI rebuilds) and **Event State** (one-time UI side effects):

**Data State** (extends `BaseDataStateCubit`):
```dart
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  factory AuthState({
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}
```

**Event State** (extends `BaseCubitEvent`):
```dart
@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const factory AuthEvent.navigateToHome() = NavigateToHome;
  const factory AuthEvent.showError(String message) = ShowError;
}
```

#### BLoC Example

```dart
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthBloc(this._loginUseCase) : super(const AuthState());

  Future<void> login(String email, String password) async {
    showLoading(); // Emits loading event
    
    final result = await _loginUseCase(email: email, password: password);
    
    hideLoading(); // Hides loading
    
    result.when(
      success: (user) {
        emit(state.copyWith(user: user)); // Update data state
        emit(const AuthEvent.navigateToHome()); // Emit navigation event
      },
      failure: (failure) {
        showMessage(failure.message); // Show error message
      },
    );
  }
}
```

### Showing Loading Dialog

Show loading (invoke inside cubit):
```dart
showLoading()
```

Hide loading (invoke inside cubit):
```dart
hideLoading()
```

Custom loading widget:
```dart
import 'package:base_bloc_module/common/base_bloc_config.dart';

BaseBlocConfig.instance.configLoadingWidget(() {
  return const Center(
    child: CircularProgressIndicator(),
  );
});
```

### Showing Messages

Show message (invoke inside cubit):
```dart
showMessage(String message, {MessageType type = MessageType.success})
```

Custom message widget:
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

### Navigation

Using NavigatorUtils:

```dart
// Instead of Navigator.of(context).pushNamed()
NavigatorUtils.instance.pushNamed('/home');

// Instead of Navigator.of(context).pushReplacementNamed()
NavigatorUtils.instance.pushReplacementNamed('/home');

// Instead of Navigator.of(context).pushNamedAndRemoveUntil()
NavigatorUtils.instance.pushNamedAndRemoveUntil('/home', (route) => false);
```

Config routes in `MaterialApp`:
```dart
MaterialApp(
  navigatorKey: NavigatorUtils.instance.navigatorKey,
  initialRoute: AppRoutes.login.routeName,
  routes: {
    for (AppRoutes e in AppRoutes.values)
      e.routeName: (context) => e.getPage(context)
  },
  navigatorObservers: [AppRouteTracking()],
)
```

## 🌍 Localization

Using `flutter_localizations`:

```dart
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp(
  localizationsDelegates: const [
    Languages.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
  ],
)
```

Access translations:
```dart
Text(Languages.of(context).hello)
```

## 📚 Architecture Principles

### Dependency Rules

1. **Domain Layer** → No dependencies ✅
2. **Data Layer** → Domain only ✅
3. **Presentation Layer** → Domain + Data ✅

### Key Principles

- **Separation of Concerns**: Each layer has a single responsibility
- **Dependency Inversion**: Depend on abstractions, not implementations
- **Testability**: Domain layer can be tested independently
- **Scalability**: Easy to add new features

## 📖 Documentation

- `PROJECT_ANALYSIS.md` - Detailed project structure analysis
- `CLEAN_ARCHITECTURE_AUDIT.md` - Architecture compliance audit
- `FIXES_REQUIRED.md` - Step-by-step fixes guide
- `ARCHITECTURE_RECOMMENDATIONS.md` - Architecture best practices
- `MODEL_ENTITY_MAPPING.md` - Model-Entity mapping guide

## 🔧 Development

### Code Generation

After creating new models, use cases, or repositories, run:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Adding a New Feature

1. Create feature folder structure:
```bash
mkdir -p lib/features/{feature_name}/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

2. Start with domain layer (entities, repository interfaces)
3. Implement data layer (models, data sources, repository implementations)
4. Create use cases in domain layer
5. Build presentation layer (BLoC, pages, widgets)
6. Register dependencies in DI

## 📝 License

This project is licensed under the MIT License.
