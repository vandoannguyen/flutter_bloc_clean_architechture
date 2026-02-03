# 📊 Phân Tích Cấu Trúc Dự Án

## 1. Cấu Trúc Hiện Tại (Layer-Based)

### 📁 Cấu Trúc Folder

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
│   ├── entity/            # ❌ Domain entities có JSON annotations
│   │   ├── error/
│   │   └── token/
│   ├── local/             # Local data sources
│   ├── network/            # Network data sources
│   ├── repository/         # ❌ Repository interfaces ở data layer
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

### ❌ Vấn Đề Hiện Tại

1. **Layer-Based Structure**: Code được tổ chức theo layers (bloc/, model/, view/) thay vì features
2. **Domain Layer Vi Phạm**: 
   - `model/entity/token/token_info.dart` có JSON annotations
   - `model/entity/error/business_error.dart` có JSON annotations
3. **Repository Interface Sai Vị Trí**: 
   - `model/repository/content/content_repository.dart` ở data layer
   - Repository interface phải ở domain layer
4. **Thiếu Use Cases**: Không có use cases để encapsulate business logic
5. **Business Logic Trong BLoC**: Logic nghiệp vụ nằm trong presentation layer

---

## 2. Cấu Trúc Mới (Clean Architecture - Feature-Based)

### 📁 Cấu Trúc Mục Tiêu

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

### ✅ Nguyên Tắc Clean Architecture

1. **Domain Layer (Innermost)**
   - Pure Dart, không dependencies
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

## 3. Mapping Từ Cấu Trúc Cũ Sang Mới

### Auth Feature

| Cũ | Mới |
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

| Cũ | Mới |
|----|-----|
| `api/` | `core/network/` |
| `di/` | `core/di/` |
| `exception/` | `core/error/` |
| `utils/` | `core/utils/` + `shared/utils/` |

### Shared Resources

| Cũ | Mới |
|----|-----|
| `routes/` | `shared/routes/` |
| `theme/` | `shared/theme/` |
| `widgets/` | `shared/widgets/` |
| `common/` | `shared/common/` |

---

## 4. Các Thay Đổi Chính

### 4.1. Domain Layer

**Trước:**
```dart
// ❌ model/entity/token/token_info.dart
@JsonSerializable(explicitToJson: true)
class TokenInfo {
  @JsonKey(name: 'access_token')
  String? accessToken;
  // ...
}
```

**Sau:**
```dart
// ✅ features/auth/domain/entities/token/token_entity.dart
class TokenEntity {
  final String? accessToken;
  final String? refreshToken;
  // Pure Dart, no annotations
}
```

### 4.2. Repository Pattern

**Trước:**
```dart
// ❌ model/repository/content/content_repository.dart
abstract class ContentRepository implements ContentLocal, ContentNetwork {
  // Interface ở data layer
}
```

**Sau:**
```dart
// ✅ features/auth/domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<UserEntity>> login({...});
  // Interface ở domain layer
}

// ✅ features/auth/data/repositories/auth_repository_impl.dart
@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  // Implementation ở data layer
}
```

### 4.3. Use Cases

**Trước:**
```dart
// ❌ Business logic trong BLoC
class LoginBloc extends BaseCubit<LoginState> {
  void handleLogin() {
    // Business logic here
  }
}
```

**Sau:**
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

## 5. Lợi Ích Của Cấu Trúc Mới

1. **Tách Biệt Rõ Ràng**: Mỗi layer có trách nhiệm riêng
2. **Dễ Test**: Domain layer có thể test độc lập
3. **Dễ Bảo Trì**: Code được tổ chức theo features
4. **Tái Sử Dụng**: Core và shared modules có thể dùng chung
5. **Tuân Thủ Clean Architecture**: Đúng nguyên tắc dependency rules
6. **Scalable**: Dễ thêm features mới

---

## 6. Kế Hoạch Refactoring

### Phase 1: Setup Core Structure
- [ ] Tạo `lib/core/` structure
- [ ] Tạo `lib/features/` structure
- [ ] Tạo `lib/shared/` structure

### Phase 2: Refactor Auth Feature
- [ ] Domain layer (entities, repositories, use cases)
- [ ] Data layer (models, datasources, repository impl)
- [ ] Presentation layer (BLoC, pages)

### Phase 3: Refactor Home Feature
- [ ] Áp dụng Clean Architecture pattern

### Phase 4: Move Core Infrastructure
- [ ] Di chuyển `api/` → `core/network/`
- [ ] Di chuyển `di/` → `core/di/`
- [ ] Di chuyển `exception/` → `core/error/`
- [ ] Di chuyển `utils/` → `core/utils/` + `shared/utils/`

### Phase 5: Move Shared Resources
- [ ] Di chuyển `routes/` → `shared/routes/`
- [ ] Di chuyển `theme/` → `shared/theme/`
- [ ] Di chuyển `widgets/` → `shared/widgets/`

### Phase 6: Update & Cleanup
- [ ] Update dependency injection
- [ ] Update imports
- [ ] Xóa folders cũ
- [ ] Update README.md
