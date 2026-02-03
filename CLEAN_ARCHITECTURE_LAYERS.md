# 🏗️ Các Tầng trong Clean Architecture

## 📐 Tổng Quan

Clean Architecture chia ứng dụng thành **3 tầng chính** và **2 tầng hỗ trợ**:

```
┌─────────────────────────────────────────────┐
│         Presentation Layer (UI)              │ ← Tầng ngoài cùng
│         (flutter_bloc, widgets)              │
└─────────────────────────────────────────────┘
                    ↓ depends on
┌─────────────────────────────────────────────┐
│         Domain Layer (Business Logic)       │ ← Tầng trong cùng
│         (entities, use cases, interfaces)   │
└─────────────────────────────────────────────┘
                    ↑ depends on
┌─────────────────────────────────────────────┐
│         Data Layer (Implementation)         │ ← Tầng giữa
│         (models, repositories, APIs)          │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│         Core (Infrastructure)               │ ← Hỗ trợ
│         (error, network, DI, utils)        │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│         Shared (Common Resources)           │ ← Hỗ trợ
│         (routes, theme, widgets, utils)      │
└─────────────────────────────────────────────┘
```

---

## 🎯 1. Domain Layer (Tầng Nghiệp Vụ)

### 📍 Vị Trí
- **Innermost layer** - Tầng trong cùng
- **Không phụ thuộc** vào bất kỳ tầng nào khác
- Pure Dart, không có framework dependencies

### 📁 Cấu Trúc
```
lib/features/{feature}/domain/
├── entities/          # Business objects
├── repositories/      # Repository interfaces
└── usecases/         # Business logic
```

### 🎯 Tác Dụng

#### 1. **Entities** (Đối Tượng Nghiệp Vụ)
- **Mục đích**: Đại diện cho các đối tượng nghiệp vụ trong hệ thống
- **Đặc điểm**:
  - Pure Dart classes (không có JSON annotations)
  - Không phụ thuộc framework
  - Chứa business logic cơ bản
- **Ví dụ**:
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

#### 2. **Repository Interfaces** (Giao Diện Repository)
- **Mục đích**: Định nghĩa contract cho data operations
- **Đặc điểm**:
  - Abstract classes/interfaces
  - Chỉ định nghĩa methods, không implement
  - Sử dụng domain entities, không phải data models
- **Ví dụ**:
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

#### 3. **Use Cases** (Logic Nghiệp Vụ)
- **Mục đích**: Encapsulate business logic cho một use case cụ thể
- **Đặc điểm**:
  - Mỗi use case = một business operation
  - Sử dụng repository interfaces
  - Có thể có business validation
- **Ví dụ**:
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

### ✅ Nguyên Tắc Domain Layer

1. **Không phụ thuộc** vào bất kỳ tầng nào
2. **Pure Dart** - Không có framework dependencies
3. **Business Logic** - Chứa tất cả logic nghiệp vụ
4. **Testable** - Có thể test độc lập, không cần UI hay API

---

## 💾 2. Data Layer (Tầng Dữ Liệu)

### 📍 Vị Trí
- **Middle layer** - Tầng giữa
- **Phụ thuộc** vào Domain Layer
- Implement các interfaces từ Domain Layer

### 📁 Cấu Trúc
```
lib/features/{feature}/data/
├── datasources/       # Remote & Local data sources
│   ├── remote/       # API calls
│   └── local/        # Local storage (SharedPreferences, etc.)
├── models/           # Data models (JSON serializable)
├── mappers/          # Model ↔ Entity converters
└── repositories/     # Repository implementations
```

### 🎯 Tác Dụng

#### 1. **Data Sources** (Nguồn Dữ Liệu)
- **Remote Data Source**: Gọi API, fetch data từ server
- **Local Data Source**: Lưu trữ local (SharedPreferences, SQLite, etc.)
- **Ví dụ**:
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

#### 2. **Models** (Mô Hình Dữ Liệu)
- **Mục đích**: Đại diện cho data từ API/local storage
- **Đặc điểm**:
  - JSON serializable (có annotations)
  - Có thể convert sang Entity
- **Ví dụ**:
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

#### 3. **Mappers** (Bộ Chuyển Đổi)
- **Mục đích**: Convert giữa Model (Data) và Entity (Domain)
- **Ví dụ**:
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

#### 4. **Repository Implementations** (Triển Khai Repository)
- **Mục đích**: Implement các repository interfaces từ Domain Layer
- **Đặc điểm**:
  - Sử dụng data sources để fetch data
  - Convert Model → Entity trước khi return
- **Ví dụ**:
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

### ✅ Nguyên Tắc Data Layer

1. **Phụ thuộc Domain** - Chỉ phụ thuộc vào Domain Layer
2. **Implement Interfaces** - Implement các repository interfaces
3. **Data Conversion** - Convert Model ↔ Entity
4. **Error Handling** - Xử lý errors và convert sang Failure

---

## 🎨 3. Presentation Layer (Tầng Giao Diện)

### 📍 Vị Trí
- **Outermost layer** - Tầng ngoài cùng
- **Phụ thuộc** vào Domain Layer và Data Layer
- Tương tác trực tiếp với người dùng

### 📁 Cấu Trúc
```
lib/features/{feature}/presentation/
├── bloc/             # State management (BLoC/Cubit)
├── pages/            # UI screens
└── widgets/          # Feature-specific widgets
```

### 🎯 Tác Dụng

#### 1. **BLoC/Cubit** (State Management)
- **Mục đích**: Quản lý state và business logic coordination
- **Đặc điểm**:
  - Sử dụng Use Cases từ Domain Layer
  - Không chứa business logic (chỉ coordination)
  - Emit states để UI rebuild
- **Ví dụ**:
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
        emit(state.copyWith(user: user, isAuthenticated: true));
        emit(const AuthEvent.navigateToHome());
      },
      failure: (failure) {
        showMessage(failure.message);
      },
    );
  }
}
```

#### 2. **State** (Trạng Thái)
- **Data State**: Chứa data để UI hiển thị (triggers rebuild)
- **Event State**: One-time events (navigation, messages, dialogs)
- **Ví dụ**:
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

#### 3. **Pages** (Màn Hình)
- **Mục đích**: UI screens, tương tác với người dùng
- **Đặc điểm**:
  - Sử dụng BLoC để quản lý state
  - Listen events để xử lý side effects
- **Ví dụ**:
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

#### 4. **Widgets** (Thành Phần UI)
- **Mục đích**: Feature-specific widgets
- **Ví dụ**: Custom buttons, cards, forms cho feature đó

### ✅ Nguyên Tắc Presentation Layer

1. **Phụ thuộc Domain** - Sử dụng Use Cases từ Domain
2. **Không Business Logic** - Chỉ coordination, không chứa business logic
3. **State Management** - Quản lý UI state
4. **User Interaction** - Xử lý user input và hiển thị output

---

## 🔧 4. Core Layer (Tầng Hạ Tầng)

### 📍 Vị Trí
- **Shared infrastructure** - Hạ tầng dùng chung
- **Không phụ thuộc** vào features
- **Được sử dụng** bởi tất cả các layers

### 📁 Cấu Trúc
```
lib/core/
├── error/            # Error handling (Result, Failure)
├── network/          # Network configuration (DioClient)
├── di/               # Dependency injection setup
├── utils/            # Core utilities
├── constants/        # App constants
└── mappers/          # Base mapper interfaces
```

### 🎯 Tác Dụng

#### 1. **Error Handling**
- `Result<T>` - Type-safe success/failure handling
- `Failure` - Các loại errors (Server, Network, Validation, etc.)

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

## 🎨 5. Shared Layer (Tầng Dùng Chung)

### 📍 Vị Trí
- **Common resources** - Tài nguyên dùng chung
- **UI-related** - Liên quan đến UI
- **Được sử dụng** bởi Presentation Layer

### 📁 Cấu Trúc
```
lib/shared/
├── routes/           # Routing configuration
├── theme/            # Theme, styles
├── widgets/          # Common widgets
└── utils/            # Shared utilities
```

### 🎯 Tác Dụng

#### 1. **Routes**
- Route definitions, navigation setup

#### 2. **Theme**
- Colors, text styles, theme data

#### 3. **Widgets**
- Reusable UI components (buttons, cards, etc.)

#### 4. **Utils**
- Navigation utils, shared preferences, etc.

---

## 🔄 Dependency Flow (Luồng Phụ Thuộc)

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

1. **Domain** → **Không phụ thuộc** gì cả ✅
2. **Data** → **Chỉ phụ thuộc** Domain ✅
3. **Presentation** → **Phụ thuộc** Domain + Data ✅
4. **Core** → **Không phụ thuộc** features ✅
5. **Shared** → **Không phụ thuộc** features ✅

---

## 📊 So Sánh Các Tầng

| Tầng | Phụ Thuộc | Framework | Business Logic | Testability |
|------|-----------|-----------|----------------|-------------|
| **Domain** | Không | Không | Có | Rất cao ✅ |
| **Data** | Domain | Có (Dio, etc.) | Không | Cao ✅ |
| **Presentation** | Domain + Data | Có (Flutter) | Không | Trung bình ⚠️ |
| **Core** | Không | Có | Không | Cao ✅ |
| **Shared** | Không | Có (Flutter) | Không | Trung bình ⚠️ |

---

## 🎯 Tóm Tắt

### Domain Layer
- **Mục đích**: Business logic, entities, use cases
- **Đặc điểm**: Pure Dart, không dependencies
- **Vai trò**: Core của ứng dụng

### Data Layer
- **Mục đích**: Fetch và lưu trữ data
- **Đặc điểm**: Implement domain interfaces
- **Vai trò**: Bridge giữa Domain và external sources

### Presentation Layer
- **Mục đích**: UI và user interaction
- **Đặc điểm**: Sử dụng Use Cases, quản lý state
- **Vai trò**: Interface với người dùng

### Core Layer
- **Mục đích**: Infrastructure, error handling, DI
- **Đặc điểm**: Shared across features
- **Vai trò**: Hỗ trợ cho tất cả layers

### Shared Layer
- **Mục đích**: Common UI resources
- **Đặc điểm**: Reusable components
- **Vai trò**: Hỗ trợ Presentation Layer

---

## 📚 Xem Thêm

- `README.md` - Project overview
- `PROJECT_ANALYSIS.md` - Detailed structure analysis
- `FORM_VALIDATION_GUIDE.md` - Form validation guide
- `ARCHITECTURE_RECOMMENDATIONS.md` - Best practices
