# 📊 Project Structure Analysis

## 1. Current Structure (Layer-Based)

### 📁 Folder Structure

```
lib/
├── api/                    # Network configuration
│   ├── dio_client.dart
│   ├── url_config.dart
│   └── multipart_file_extended.dart
│
├── bloc/                   # State management (layer-based)
│   ├── app/
│   ├── home/
│   ├── login/
│   └── register_account/
│
├── model/                  # Data models (mixed concerns)
│   ├── entity/            # ❌ Domain entities have JSON annotations
│   │   ├── error/
│   │   └── token/
│   ├── local/             # Local data sources
│   ├── network/            # Network data sources
│   ├── repository/         # ❌ Repository interfaces in data layer
│   └── request/           # API request models
│
├── view/                   # UI screens (layer-based)
│   ├── home/
│   ├── login/
│   └── register_account/
│
├── common/                 # Common utilities
├── di/                     # Dependency injection
├── exception/              # Exception handling
├── routes/                 # Routing configuration
├── theme/                  # Theme configuration
├── utils/                  # Utility functions
└── widgets/                # Common widgets
```

### ❌ Current Issues

1. **Layer-Based Structure**: Code is organized by layers (bloc/, model/, view/) instead of features
2. **Domain Layer Violations**:
   - `model/entity/token/token_info.dart` has JSON annotations
   - `model/entity/error/business_error.dart` has JSON annotations
3. **Repository Interface in Wrong Place**:
   - `model/repository/content/content_repository.dart` is in data layer
   - Repository interface must be in domain layer
4. **Missing Use Cases**: No use cases to encapsulate business logic
5. **Business Logic in BLoC**: Business logic lives in presentation layer

---

## 2. New Structure (Clean Architecture - Feature-Based)

### 📁 Target Structure

```
lib/
├── core/                   # Core infrastructure (shared across features)
│   ├── error/             # Error handling (Result, Failure)
│   ├── network/            # Network configuration
│   ├── di/                 # Dependency injection
│   ├── utils/              # Core utilities
│   ├── constants/          # App constants
│   └── mappers/            # Base mapper interfaces
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
│   │       └── widgets/      # Feature-specific widgets
│   │
│   └── home/              # Home feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── shared/                 # Shared resources
    ├── routes/            # Routing
    ├── theme/             # Theme
    ├── widgets/           # Common widgets
    └── utils/             # Shared utilities
```

### ✅ Clean Architecture Principles

1. **Domain Layer (Innermost)**
   - Pure Dart, no dependencies
   - Entities: Pure Dart classes
   - Repository Interfaces: Abstract classes
   - Use Cases: Business logic

2. **Data Layer**
   - Implements domain interfaces
   - Models: JSON serializable
   - Data Sources: API & Local storage
   - Mappers: Convert Model ↔ Entity

3. **Presentation Layer**
   - BLoC/Cubit: State management
   - Pages: UI screens
   - Widgets: Feature-specific UI

4. **Dependency Rules**
   - Domain → No dependencies ✅
   - Data → Domain only ✅
   - Presentation → Domain + Data ✅

---

## 3. Mapping from Old to New Structure

### Auth Feature

| Old | New |
|----|-----|
| `bloc/login/` | `features/auth/presentation/bloc/` |
| `view/login/` | `features/auth/presentation/pages/` |
| `model/entity/token/` | `features/auth/domain/entities/token/` |
| `model/entity/error/` | `features/auth/data/models/` (BusinessErrorModel) |
| `model/repository/content/` | `features/auth/domain/repositories/` (interface) |
| `model/repository/content/` | `features/auth/data/repositories/` (implementation) |
| `model/network/content/` | `features/auth/data/datasources/` |
| `model/local/content/` | `features/auth/data/datasources/` |
| `model/request/login_request.dart` | `features/auth/data/models/login_request.dart` |

### Core Infrastructure

| Old | New |
|----|-----|
| `api/` | `core/network/` |
| `di/` | `core/di/` |
| `exception/` | `core/error/` |
| `utils/` | `core/utils/` + `shared/utils/` |

### Shared Resources

| Old | New |
|----|-----|
| `routes/` | `shared/routes/` |
| `theme/` | `shared/theme/` |
| `widgets/` | `shared/widgets/` |
| `common/` | `shared/common/` |

---

## 4. Main Changes

### 4.1. Domain Layer

**Before:**
```dart
// ❌ model/entity/token/token_info.dart
@JsonSerializable(explicitToJson: true)
class TokenInfo {
  @JsonKey(name: 'access_token')
  String? accessToken;
  // ...
}
```

**After:**
```dart
// ✅ features/auth/domain/entities/token/token_entity.dart
class TokenEntity {
  final String? accessToken;
  final String? refreshToken;
  // Pure Dart, no annotations
}
```

### 4.2. Repository Pattern

**Before:**
```dart
// ❌ model/repository/content/content_repository.dart
abstract class ContentRepository implements ContentLocal, ContentNetwork {
  // Interface in data layer
}
```

**After:**
```dart
// ✅ features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<UserEntity>> login({...});
  // Interface in domain layer
}

// ✅ features/auth/data/repositories/auth_repository_impl.dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // Implementation in data layer
}
```

### 4.3. Use Cases

**Before:**
```dart
// ❌ Business logic in BLoC
class LoginBloc extends BaseCubit<LoginState> {
  void handleLogin() {
    // Business logic here
  }
}
```

**After:**
```dart
// ✅ features/auth/domain/usecases/login_usecase.dart
@injectable
class LoginUseCase {
  final AuthRepository _repository;
  
  Future<Result<UserEntity>> call({...}) {
    // Business logic here
  }
}

// ✅ features/auth/presentation/bloc/auth_bloc.dart
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase;
  
  Future<void> login(...) async {
    final result = await _loginUseCase(...);
    // Handle result
  }
}
```

---

## 5. Benefits of the New Structure

1. **Clear Separation**: Each layer has a single responsibility
2. **Easier Testing**: Domain layer can be tested in isolation
3. **Easier Maintenance**: Code organized by features
4. **Reusability**: Core and shared modules can be reused
5. **Clean Architecture Compliant**: Correct dependency rules
6. **Scalable**: Easy to add new features

---

## 6. Refactoring Plan

### Phase 1: Setup Core Structure
- [ ] Create `lib/core/` structure
- [ ] Create `lib/features/` structure
- [ ] Create `lib/shared/` structure

### Phase 2: Refactor Auth Feature
- [ ] Domain layer (entities, repositories, use cases)
- [ ] Data layer (models, datasources, repository impl)
- [ ] Presentation layer (BLoC, pages)

### Phase 3: Refactor Home Feature
- [ ] Apply Clean Architecture pattern

### Phase 4: Move Core Infrastructure
- [ ] Move `api/` → `core/network/`
- [ ] Move `di/` → `core/di/`
- [ ] Move `exception/` → `core/error/`
- [ ] Move `utils/` → `core/utils/` + `shared/utils/`

### Phase 5: Move Shared Resources
- [ ] Move `routes/` → `shared/routes/`
- [ ] Move `theme/` → `shared/theme/`
- [ ] Move `widgets/` → `shared/widgets/`

### Phase 6: Update & Cleanup
- [ ] Update dependency injection
- [ ] Update imports
- [ ] Remove old folders
- [ ] Update README.md
