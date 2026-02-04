# 📋 Mandatory Requirements

## 🎯 Overview

This document lists **MANDATORY** requirements that must be followed when developing the Flutter BLoC Clean Architecture project.

---

## 1. 🏗️ Project Structure (MANDATORY)

### 1.1. Feature-Based Structure

**REQUIREMENT:** All code must be organized by **feature**, not by layer.

```
✅ CORRECT:
lib/features/{feature_name}/
├── data/
├── domain/
└── presentation/

❌ WRONG:
lib/
├── bloc/
├── model/
└── view/
```

### 1.2. Required Feature Structure

Each feature **MUST** have all three layers:

```
lib/features/{feature_name}/
├── data/                    # REQUIRED
│   ├── datasources/        # REQUIRED
│   ├── models/             # REQUIRED
│   └── repositories/       # REQUIRED
├── domain/                  # REQUIRED
│   ├── entities/           # REQUIRED
│   ├── repositories/       # REQUIRED (interfaces)
│   └── usecases/           # REQUIRED
└── presentation/            # REQUIRED
    ├── bloc/               # REQUIRED
    ├── pages/              # REQUIRED
    └── widgets/            # OPTIONAL (feature-specific)
```

---

## 2. 🔄 Dependency Rules (MANDATORY)

### 2.1. Domain Layer

**REQUIREMENT:** Domain Layer **MUST NOT** depend on any other layer.

```dart
✅ CORRECT:
// features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  // Pure Dart, no imports from data/presentation/core/shared
}

❌ WRONG:
import 'package:base_flutter_bloc/features/auth/data/models/user_model.dart'; // ❌
import 'package:flutter/material.dart'; // ❌
import 'package:dio/dio.dart'; // ❌
```

**CHECKLIST:**
- [ ] No imports from `data/`, `presentation/`, `core/`, `shared/`
- [ ] No imports from Flutter framework (`flutter/material.dart`, etc.)
- [ ] No imports from external packages (Dio, SharedPreferences, etc.)
- [ ] Only imports from `core/error/` (Result, Failure) - ALLOWED
- [ ] Pure Dart classes, no JSON annotations

### 2.2. Data Layer

**REQUIREMENT:** Data Layer **MAY ONLY** depend on Domain Layer.

```dart
✅ CORRECT:
// features/auth/data/repositories/auth_repository_impl.dart
import 'package:base_flutter_bloc/features/auth/domain/repositories/auth_repository.dart';
import 'package:base_flutter_bloc/features/auth/domain/entities/user_entity.dart';
import 'package:base_flutter_bloc/core/error/result.dart';

❌ WRONG:
import 'package:base_flutter_bloc/features/auth/presentation/bloc/auth_bloc.dart'; // ❌
```

**CHECKLIST:**
- [ ] Only import from same feature's `domain/` or `core/error/`
- [ ] No import from `presentation/`
- [ ] No import from `shared/` (unless truly needed for infrastructure)
- [ ] Models use `@JsonSerializable()` (do NOT use Freezed for models)

### 2.3. Presentation Layer

**REQUIREMENT:** Presentation Layer **MAY** depend on Domain + Data + Shared.

```dart
✅ CORRECT:
// features/auth/presentation/bloc/auth_bloc.dart
import 'package:base_flutter_bloc/features/auth/domain/usecases/login_usecase.dart';
import 'package:base_flutter_bloc/shared/utils/navigate_utils.dart';

❌ WRONG:
import 'package:base_flutter_bloc/features/auth/data/datasources/auth_remote_datasource.dart'; // ❌ Direct access
```

**CHECKLIST:**
- [ ] BLoC uses only Use Cases, does not call Repository or DataSource directly
- [ ] Pages use only BLoC, do not call Use Cases directly
- [ ] May import from `shared/` (routes, theme, widgets, utils)

### 2.4. Core Layer

**REQUIREMENT:** Core Layer **MUST NOT** depend on features.

```dart
✅ CORRECT:
// core/error/result.dart
class Result<T> {
  // No feature dependencies
}

❌ WRONG:
import 'package:base_flutter_bloc/features/auth/domain/entities/user_entity.dart'; // ❌
```

### 2.5. Shared Layer

**REQUIREMENT:** Shared Layer **MUST NOT** depend on features.

```dart
✅ CORRECT:
// shared/routes/routes.dart
enum AppRoutes {
  login,
  home,
}

❌ WRONG:
import 'package:base_flutter_bloc/features/auth/presentation/pages/login_screen.dart'; // ❌
// Should use factory pattern or route builder
```

---

## 3. 📦 Models and Entities (MANDATORY)

### 3.1. Domain Entities

**REQUIREMENT:** Domain Entities **MUST** be Pure Dart with no JSON annotations.

```dart
✅ CORRECT:
// features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  
  const UserEntity({
    required this.id,
    required this.email,
  });
}

❌ WRONG:
@JsonSerializable() // ❌
class UserEntity {
  // ...
}
```

**CHECKLIST:**
- [ ] No `@JsonSerializable()`, `@freezed`, `@JsonKey()`
- [ ] No `fromJson()`, `toJson()` methods
- [ ] Pure Dart class with business logic methods

### 3.2. Data Models

**REQUIREMENT:** Data Models **MUST** use `@JsonSerializable()`, not Freezed.

```dart
✅ CORRECT:
// features/auth/data/models/user_model.dart
@JsonSerializable(explicitToJson: true)
class UserModel {
  final String id;
  final String email;
  
  UserModel({required this.id, required this.email});
  
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

❌ WRONG:
@freezed // ❌
class UserModel with _$UserModel {
  // ...
}
```

**CHECKLIST:**
- [ ] Use `@JsonSerializable()` for all models
- [ ] Have `fromJson()` and `toJson()` methods
- [ ] Have extension method `toEntity()` to convert to Entity

### 3.3. Model-Entity Mapping

**REQUIREMENT:** **MUST** have a mapper between Model and Entity.

```dart
✅ CORRECT:
// features/auth/data/models/user_model.dart
extension UserModelExtension on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
    );
  }
}
```

---

## 4. 🎯 Use Cases (MANDATORY)

### 4.1. Use Case Pattern

**REQUIREMENT:** Each business operation **MUST** have its own Use Case.

```dart
✅ CORRECT:
// features/auth/domain/usecases/login_usecase.dart
@injectable
class LoginUseCase {
  final AuthRepository _repository;
  
  LoginUseCase(this._repository);
  
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
  }) async {
    // Business logic here
  }
}
```

**CHECKLIST:**
- [ ] One Use Case = one business operation
- [ ] Use Case uses Repository interface (not implementation)
- [ ] Use Case may contain business validation
- [ ] Use Case returns `Result<T>`

### 4.2. Business Logic Location

**REQUIREMENT:** Business logic **MUST** live in Use Cases, not in BLoC.

```dart
✅ CORRECT:
// Use Case has business logic
class LoginUseCase {
  Future<Result<UserEntity>> call({...}) async {
    if (!email.isValidEmail) {
      return Result.failure(Failure.validation(...));
    }
    // Business logic
  }
}

// BLoC only coordinates
class AuthBloc extends BaseCubit<AuthState> {
  Future<void> login(String email, String password) async {
    final result = await _loginUseCase(email: email, password: password);
    // Handle result
  }
}

❌ WRONG:
// Business logic in BLoC
class AuthBloc extends BaseCubit<AuthState> {
  Future<void> login(String email, String password) async {
    if (!email.isValidEmail) { // ❌ Business logic in BLoC
      return;
    }
  }
}
```

---

## 5. 🔌 Repository Pattern (MANDATORY)

### 5.1. Repository Interface

**REQUIREMENT:** Repository interface **MUST** be in Domain Layer.

```dart
✅ CORRECT:
// features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<UserEntity>> login({
    required String email,
    required String password,
  });
}

❌ WRONG:
// features/auth/data/repositories/auth_repository.dart
abstract class AuthRepository { // ❌ Wrong location
  // ...
}
```

### 5.2. Repository Implementation

**REQUIREMENT:** Repository implementation **MUST** be in Data Layer and implement the Domain interface.

```dart
✅ CORRECT:
// features/auth/data/repositories/auth_repository_impl.dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  
  @override
  Future<Result<UserEntity>> login({...}) async {
    // Implementation
  }
}
```

---

## 6. 🎨 Presentation Layer (MANDATORY)

### 6.1. BLoC Pattern

**REQUIREMENT:** BLoC **MUST** extend `BaseCubit` and use only Use Cases.

```dart
✅ CORRECT:
@injectable
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  
  AuthBloc(this._loginUseCase) : super(const AuthState());
  
  Future<void> login(String email, String password) async {
    final result = await _loginUseCase(email: email, password: password);
    // Handle result
  }
}

❌ WRONG:
class AuthBloc extends Cubit<AuthState> { // ❌ Does not extend BaseCubit
  final AuthRepository _repository; // ❌ Direct access to repository
}
```

### 6.2. State Management

**REQUIREMENT:** Data State and Event State **MUST** be separate.

```dart
✅ CORRECT:
// Data State
@Freezed(equal: true)
class AuthState extends BaseDataStateCubit with _$AuthState {
  factory AuthState({UserEntity? user}) = _AuthState;
}

// Event State
@freezed
class AuthEvent extends BaseCubitEvent with _$AuthEvent {
  const factory AuthEvent.navigateToHome() = NavigateToHome;
}

❌ WRONG:
class AuthState {
  UserEntity? user;
  bool shouldNavigate; // ❌ Event in Data State
}
```

### 6.3. BlocBuilder Usage

**REQUIREMENT:** **MUST** use `BlocBuilderDataState` instead of `BlocBuilder`.

```dart
✅ CORRECT:
BlocBuilderDataState<AuthBloc, AuthState>(
  bloc: bloc,
  builder: (context, state) => Text(state.user?.email ?? ''),
)

❌ WRONG:
BlocBuilder<AuthBloc, AuthState>( // ❌ Rebuilds on Event State too
  builder: (context, state) => Text(state.user?.email ?? ''),
)
```

---

## 7. 🔧 Dependency Injection (MANDATORY)

### 7.1. Injectable Annotations

**REQUIREMENT:** All Use Cases, Repositories, BLoCs **MUST** have `@injectable` annotation.

```dart
✅ CORRECT:
@injectable
class LoginUseCase {
  // ...
}

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // ...
}

@injectable
class AuthBloc extends BaseCubit<AuthState> {
  // ...
}
```

### 7.2. DI Registration

**REQUIREMENT:** All dependencies **MUST** be registered in `core/di/injection_container.dart`.

---

## 8. ✅ Validation (MANDATORY)

### 8.1. Input Validation

**REQUIREMENT:** Input validation (format, required) **MUST** be in Presentation Layer (BLoC).

```dart
✅ CORRECT:
// Presentation Layer - BLoC
class RegisterBloc extends BaseCubit<RegisterState> {
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.isValidEmail) {
      return 'Invalid email format';
    }
    return null;
  }
}
```

### 8.2. Business Validation

**REQUIREMENT:** Business validation **MUST** be in Domain Layer (Use Cases).

```dart
✅ CORRECT:
// Domain Layer - Use Case
class RegisterUseCase {
  Future<Result<UserEntity>> call({...}) async {
    // Business validation: Check if email already exists
    final checkResult = await _repository.checkEmailExists(email);
    if (checkResult.exists) {
      return Result.failure(Failure.validation(...));
    }
  }
}
```

---

## 9. 📁 File Organization (MANDATORY)

### 9.1. Index Files

**REQUIREMENT:** Each folder **MUST** have an `index.dart` that exports its files.

```dart
✅ CORRECT:
// features/auth/domain/entities/index.dart
export 'user_entity.dart';
export 'token/token_entity.dart';
```

### 9.2. Naming Conventions

**REQUIREMENT:** Follow naming conventions:

- Entities: `{name}_entity.dart`
- Models: `{name}_model.dart`
- Repositories: `{name}_repository.dart` (interface), `{name}_repository_impl.dart` (implementation)
- Use Cases: `{action}_usecase.dart` (e.g., `login_usecase.dart`)
- BLoCs: `{feature}_bloc.dart`
- States: `{feature}_state.dart`
- Pages: `{feature}_screen.dart` or `{feature}_page.dart`

---

## 10. 🚫 Forbidden (FORBIDDEN)

### 10.1. Domain Layer

- ❌ **MUST NOT** import from `data/`, `presentation/`, `shared/`
- ❌ **MUST NOT** use Flutter framework
- ❌ **MUST NOT** have JSON annotations
- ❌ **MUST NOT** have business logic in Entities (only basic getters)

### 10.2. Data Layer

- ❌ **MUST NOT** import from `presentation/`
- ❌ **MUST NOT** contain business logic (only data transformation)
- ❌ **MUST NOT** use Freezed for Models (only `@JsonSerializable()`)

### 10.3. Presentation Layer

- ❌ **MUST NOT** call Repository or DataSource directly (must go through Use Case)
- ❌ **MUST NOT** contain business logic (only coordination)
- ❌ **MUST NOT** use `BlocBuilder` instead of `BlocBuilderDataState`

### 10.4. Core & Shared

- ❌ **MUST NOT** import from `features/`
- ❌ **MUST NOT** contain feature-specific code

---

## 11. ✅ Checklist When Creating a New Feature

Before committing a new feature, **MUST** verify:

### Domain Layer
- [ ] Entities are Pure Dart, no JSON annotations
- [ ] Repository interfaces in domain layer
- [ ] Use Cases contain business logic
- [ ] No imports from data/presentation/core/shared (except core/error)

### Data Layer
- [ ] Models use `@JsonSerializable()`
- [ ] Models have `toEntity()` extension
- [ ] Repository implementations implement domain interface
- [ ] Only import from domain and core/error

### Presentation Layer
- [ ] BLoC extends `BaseCubit`
- [ ] BLoC uses only Use Cases
- [ ] State separates Data State and Event State
- [ ] Use `BlocBuilderDataState`
- [ ] Pages extend `BaseViewCubit` or `BaseViewCubitState`

### General
- [ ] All dependencies have `@injectable` annotation
- [ ] `index.dart` in each folder
- [ ] Naming conventions followed
- [ ] No business logic in the wrong layer

---

## 📚 Reference Documentation

- `CLEAN_ARCHITECTURE_LAYERS.md` - Layer details
- `DEVELOPMENT_RULES.md` - Rules for new feature development
- `FORM_VALIDATION_GUIDE.md` - Validation guide
- `README.md` - Project overview

---

**Note:** All requirements above are **MANDATORY**. Violating any requirement breaks Clean Architecture and must be fixed immediately.
