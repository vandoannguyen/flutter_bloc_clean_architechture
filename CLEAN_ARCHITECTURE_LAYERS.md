# 🏗️ Layers in Clean Architecture

## 📐 Overview

Clean Architecture divides the application into **3 main layers** and **2 supporting layers**:

```
┌─────────────────────────────────────────────┐
│         Presentation Layer (UI)              │ ← Outermost layer
│         (flutter_bloc, widgets)              │
└─────────────────────────────────────────────┘
                    ↓ depends on
┌─────────────────────────────────────────────┐
│         Domain Layer (Business Logic)       │ ← Innermost layer
│         (entities, use cases, interfaces)   │
└─────────────────────────────────────────────┘
                    ↑ depends on
┌─────────────────────────────────────────────┐
│         Data Layer (Implementation)         │ ← Middle layer
│         (models, repositories, APIs)          │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│         Core (Infrastructure)               │ ← Supporting
│         (error, network, DI, utils)        │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│         Shared (Common Resources)           │ ← Supporting
│         (routes, theme, widgets, utils)      │
└─────────────────────────────────────────────┘
```

---

## 🎯 1. Domain Layer (Business Layer)

### 📍 Position
- **Innermost layer**
- **Does not depend** on any other layer
- Pure Dart, no framework dependencies

### 📁 Structure
```
lib/features/{feature}/domain/
├── entities/          # Business objects
├── repositories/      # Repository interfaces
└── usecases/         # Business logic
```

### 🎯 Purpose

#### 1. **Entities** (Business Objects)
- **Purpose**: Represent business objects in the system
- **Characteristics**:
  - Pure Dart classes (no JSON annotations)
  - No framework dependencies
  - May contain basic business logic
- **Example**:
```dart
// lib/features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  final String? name;
  
  const UserEntity({
    required this.id,
    required this.email,
    this.name,
  });
  
  // Business logic methods
  bool get isValidEmail => email.contains('@');
}
```

#### 2. **Repository Interfaces** (Repository Contracts)
- **Purpose**: Define contracts for data operations
- **Characteristics**:
  - Abstract classes/interfaces
  - Only declare methods, no implementation
  - Use domain entities, not data models
- **Example**:
```dart
// lib/features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });
  
  Future<Result<void>> logout();
}
```

#### 3. **Use Cases** (Business Logic)
- **Purpose**: Encapsulate business logic for a specific use case
- **Characteristics**:
  - One use case = one business operation
  - Use repository interfaces
  - May contain business validation
- **Example**:
```dart
// lib/features/auth/domain/usecases/login_usecase.dart
@injectable
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Business validation
    if (!email.isValidEmail) {
      return Result.failure(
        Failure.validation(message: 'Invalid email'),
      );
    }
    
    // Call repository
    return await _repository.login(email: email, password: password);
  }
}
```

### ✅ Domain Layer Principles

1. **No dependencies** on any other layer
2. **Pure Dart** - No framework dependencies
3. **Business Logic** - Contains all business logic
4. **Testable** - Can be tested in isolation, no UI or API needed

---

## 💾 2. Data Layer

### 📍 Position
- **Middle layer**
- **Depends** on Domain Layer
- Implements interfaces from Domain Layer

### 📁 Structure
```
lib/features/{feature}/data/
├── datasources/       # Remote & Local data sources
│   ├── remote/       # API calls
│   └── local/        # Local storage (SharedPreferences, etc.)
├── models/           # Data models (JSON serializable)
├── mappers/          # Model ↔ Entity converters
└── repositories/     # Repository implementations
```

### 🎯 Purpose

#### 1. **Data Sources** (Data Providers)
- **Remote Data Source**: Call API, fetch data from server
- **Local Data Source**: Local storage (SharedPreferences, SQLite, etc.)
- **Example**:
```dart
// lib/features/auth/data/datasources/remote/auth_remote_datasource.dart
@RestApi()
abstract class AuthRemoteDataSource {
  @POST("/login")
  Future<Map<String, dynamic>> login(@Body() LoginRequest request);
}

// lib/features/auth/data/datasources/local/auth_local_datasource.dart
abstract class AuthLocalDataSource {
  Future<void> saveToken(TokenModel token);
  Future<TokenModel?> getToken();
}
```

#### 2. **Models** (Data Models)
- **Purpose**: Represent data from API/local storage
- **Characteristics**:
  - JSON serializable (with annotations)
  - Can be converted to Entity
- **Example**:
```dart
// lib/features/auth/data/models/user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserModel;
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      avatarUrl: avatarUrl,
    );
  }
}
```

#### 3. **Mappers** (Converters)
- **Purpose**: Convert between Model (Data) and Entity (Domain)
- **Example**:
```dart
// lib/features/auth/data/mappers/user_mapper.dart
@injectable
class UserMapper implements Mapper<UserModel, UserEntity> {
  @override
  UserEntity toEntity(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
    );
  }
  
  @override
  UserModel toModel(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
    );
  }
}
```

#### 4. **Repository Implementations**
- **Purpose**: Implement repository interfaces from Domain Layer
- **Characteristics**:
  - Use data sources to fetch data
  - Convert Model → Entity before returning
- **Example**:
```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  
  @override
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        LoginRequest(email, password),
      );
      
      final userModel = UserModel.fromJson(response);
      await _localDataSource.saveUser(userModel);
      
      return Result.success(userModel.toEntity());
    } catch (e) {
      return Result.failure(
        Failure.unknown(message: e.toString()),
      );
    }
  }
}
```

### ✅ Data Layer Principles

1. **Depends on Domain** - Only depends on Domain Layer
2. **Implement Interfaces** - Implement repository interfaces
3. **Data Conversion** - Convert Model ↔ Entity
4. **Error Handling** - Handle errors and convert to Failure

---

## 🎨 3. Presentation Layer (UI Layer)

### 📍 Position
- **Outermost layer**
- **Depends** on Domain Layer and Data Layer
- Directly interacts with the user

### 📁 Structure
```
lib/features/{feature}/presentation/
├── bloc/             # State management (BLoC/Cubit)
├── pages/            # UI screens
└── widgets/          # Feature-specific widgets
```

### 🎯 Purpose

#### 1. **BLoC/Cubit** (State Management)
- **Purpose**: Manage state and coordinate business logic
- **Characteristics**:
  - Use Use Cases from Domain Layer
  - Do not contain business logic (only coordination)
  - Emit states for UI rebuild
- **Example**:
```dart
// lib/features/auth/presentation/bloc/auth_bloc.dart
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
        emit(dataState.copyWith(user: user, isAuthenticated: true));
        emit(const AuthEvent.navigateToHome());
      },
      failure: (failure) {
        showMessage(failure.message);
      },
    );
  }
}
```

#### 2. **State** (State Types)
- **Data State**: Holds data for UI display (triggers rebuild)
- **Event State**: One-time events (navigation, messages, dialogs)
- **Example**:
```dart
// Data State
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  factory AuthState({
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthState;
}

// Event State
@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const factory AuthEvent.navigateToHome() = NavigateToHome;
  const factory AuthEvent.showError(String message) = ShowError;
}
```

#### 3. **Pages** (Screens)
- **Purpose**: UI screens, user interaction
- **Characteristics**:
  - Use BLoC for state management
  - Listen to events for side effects
- **Example**:
```dart
// lib/features/auth/presentation/pages/login_screen.dart
class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState
    extends BaseViewCubitState<AuthBloc, AuthState, AuthEvent, LoginScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return BlocBuilderDataState<AuthBloc, AuthState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              TextField(
                onChanged: (value) => bloc?.updateEmail(value),
              ),
              ElevatedButton(
                onPressed: () => bloc?.login(email, password),
                child: Text('Login'),
              ),
            ],
          ),
        );
      },
    );
  }
  
  @override
  void initEventViewModel(BuildContext context, AuthEvent state) {
    state.when(
      navigateToHome: () => Navigator.pushNamed('/home'),
      showError: (message) => showMessage(message),
    );
  }
}
```

#### 4. **Widgets** (UI Components)
- **Purpose**: Feature-specific widgets
- **Example**: Custom buttons, cards, forms for that feature

### ✅ Presentation Layer Principles

1. **Depends on Domain** - Use Use Cases from Domain
2. **No Business Logic** - Only coordination, no business logic
3. **State Management** - Manage UI state
4. **User Interaction** - Handle user input and display output

---

## 🔧 4. Core Layer (Infrastructure)

### 📍 Position
- **Shared infrastructure**
- **Does not depend** on features
- **Used by** all layers

### 📁 Structure
```
lib/core/
├── error/            # Error handling (Result, Failure)
├── network/          # Network configuration (DioClient)
├── di/               # Dependency injection setup
├── utils/            # Core utilities
├── constants/        # App constants
└── mappers/          # Base mapper interfaces
```

### 🎯 Purpose

#### 1. **Error Handling**
- `Result<T>` - Type-safe success/failure handling
- `Failure` - Error types (Server, Network, Validation, etc.)

#### 2. **Network**
- `DioClient` - HTTP client configuration
- Interceptors, error handling, token refresh

#### 3. **Dependency Injection**
- `injection_container.dart` - DI setup
- Register dependencies

#### 4. **Utilities**
- String extensions, validators, helpers

#### 5. **Constants**
- App-wide constants (API timeouts, keys, etc.)

---

## 🎨 5. Shared Layer (Common Resources)

### 📍 Position
- **Common resources**
- **UI-related**
- **Used by** Presentation Layer

### 📁 Structure
```
lib/shared/
├── routes/           # Routing configuration
├── theme/            # Theme, styles
├── widgets/          # Common widgets
└── utils/            # Shared utilities
```

### 🎯 Purpose

#### 1. **Routes**
- Route definitions, navigation setup

#### 2. **Theme**
- Colors, text styles, theme data

#### 3. **Widgets**
- Reusable UI components (buttons, cards, etc.)

#### 4. **Utils**
- Navigation utils, shared preferences, etc.

---

## 🔄 Dependency Flow

```
Presentation Layer
    ↓ depends on
Domain Layer ← (No dependencies)
    ↑ depends on
Data Layer
    ↓ uses
Core Layer (infrastructure)
    ↑ uses
Shared Layer (common resources)
```

### ✅ Dependency Rules

1. **Domain** → **No dependencies** ✅
2. **Data** → **Depends only on** Domain ✅
3. **Presentation** → **Depends on** Domain + Data ✅
4. **Core** → **Does not depend on** features ✅
5. **Shared** → **Does not depend on** features ✅

---

## 📊 Layer Comparison

| Layer | Dependencies | Framework | Business Logic | Testability |
|------|--------------|-----------|----------------|-------------|
| **Domain** | None | No | Yes | Very high ✅ |
| **Data** | Domain | Yes (Dio, etc.) | No | High ✅ |
| **Presentation** | Domain + Data | Yes (Flutter) | No | Medium ⚠️ |
| **Core** | None | Yes | No | High ✅ |
| **Shared** | None | Yes (Flutter) | No | Medium ⚠️ |

---

## 🎯 Summary

### Domain Layer
- **Purpose**: Business logic, entities, use cases
- **Characteristics**: Pure Dart, no dependencies
- **Role**: Core of the application

### Data Layer
- **Purpose**: Fetch and store data
- **Characteristics**: Implements domain interfaces
- **Role**: Bridge between Domain and external sources

### Presentation Layer
- **Purpose**: UI and user interaction
- **Characteristics**: Uses Use Cases, manages state
- **Role**: Interface with the user

### Core Layer
- **Purpose**: Infrastructure, error handling, DI
- **Characteristics**: Shared across features
- **Role**: Support for all layers

### Shared Layer
- **Purpose**: Common UI resources
- **Characteristics**: Reusable components
- **Role**: Support for Presentation Layer

---

## 📚 See Also

- `README.md` - Project overview
- `PROJECT_ANALYSIS.md` - Detailed structure analysis
- `FORM_VALIDATION_GUIDE.md` - Form validation guide
- `ARCHITECTURE_RECOMMENDATIONS.md` - Best practices
