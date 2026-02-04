# 🛠️ Development Rules & Memory

## 📋 Purpose

This document contains **rules and memory** to ensure that when developing new features:
- ✅ Clean Architecture is followed
- ✅ Current structure is not changed
- ✅ Consistency in the codebase is maintained
- ✅ Easy to maintain and scale

---

## 🎯 New Feature Creation Process

### Step 1: Create Folder Structure

```bash
# Create full structure for a new feature
mkdir -p lib/features/{feature_name}/{data/{datasources/{remote,local},models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

**Example:** Create feature `product`

```bash
mkdir -p lib/features/product/{data/{datasources/{remote,local},models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
```

### Step 2: Create Domain Layer (Start Here)

#### 2.1. Create Entities

```dart
// lib/features/product/domain/entities/product_entity.dart
class ProductEntity {
  final String id;
  final String name;
  final double price;
  
  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
  });
  
  // Business logic methods
  bool get isExpensive => price > 1000;
}
```

**Rules:**
- ✅ Pure Dart class
- ✅ No JSON annotations
- ✅ May have business logic methods (getters)
- ✅ Create `index.dart` for exports

#### 2.2. Create Repository Interface

```dart
// lib/features/product/domain/repositories/product_repository.dart
import '../../../../core/error/result.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<Result<List<ProductEntity>>> getProducts();
  Future<Result<ProductEntity>> getProductById(String id);
}
```

**Rules:**
- ✅ Abstract class
- ✅ Use domain entities
- ✅ Return `Result<T>`
- ✅ Create `index.dart` for exports

#### 2.3. Create Use Cases

```dart
// lib/features/product/domain/usecases/get_products_usecase.dart
import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository _repository;
  
  GetProductsUseCase(this._repository);
  
  Future<Result<List<ProductEntity>>> call() async {
    // Business logic here
    return await _repository.getProducts();
  }
}
```

**Rules:**
- ✅ Has `@injectable` annotation
- ✅ Inject repository interface (not implementation)
- ✅ May have business validation
- ✅ Return `Result<T>`
- ✅ Create `index.dart` for exports

### Step 3: Create Data Layer

#### 3.1. Create Models

```dart
// lib/features/product/data/models/product_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel {
  final String id;
  final String name;
  @JsonKey(name: 'price')
  final double price;
  
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
  });
  
  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

extension ProductModelExtension on ProductModel {
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
    );
  }
}
```

**Rules:**
- ✅ Use `@JsonSerializable()` (do NOT use Freezed)
- ✅ Have `fromJson()` and `toJson()`
- ✅ Have extension `toEntity()` to convert to Entity
- ✅ Create `index.dart` for exports

#### 3.2. Create Data Sources

```dart
// lib/features/product/data/datasources/remote/product_remote_datasource.dart
import 'package:retrofit/retrofit.dart';
import '../models/product_model.dart';

@RestApi()
abstract class ProductRemoteDataSource {
  @GET('/products')
  Future<List<ProductModel>> getProducts();
  
  @GET('/products/{id}')
  Future<ProductModel> getProductById(@Path('id') String id);
}
```

**Rules:**
- ✅ Remote: Use Retrofit annotations
- ✅ Local: Interface for local storage
- ✅ Return Models, not Entities
- ✅ Create `index.dart` for exports

#### 3.3. Create Repository Implementation

```dart
// lib/features/product/data/repositories/product_repository_impl.dart
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';
import '../models/product_model.dart';

@Injectable(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remoteDataSource;
  
  ProductRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<Result<List<ProductEntity>>> getProducts() async {
    try {
      final models = await _remoteDataSource.getProducts();
      final entities = models.map((model) => model.toEntity()).toList();
      return Result.success(entities);
    } catch (e) {
      return Result.failure(
        Failure.unknown(message: e.toString()),
      );
    }
  }
  
  @override
  Future<Result<ProductEntity>> getProductById(String id) async {
    try {
      final model = await _remoteDataSource.getProductById(id);
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(
        Failure.unknown(message: e.toString()),
      );
    }
  }
}
```

**Rules:**
- ✅ Has `@Injectable(as: ProductRepository)` annotation
- ✅ Implement interface from domain
- ✅ Convert Model → Entity before returning
- ✅ Handle errors and convert to `Failure`
- ✅ Create `index.dart` for exports

### Step 4: Create Presentation Layer

#### 4.1. Create State

```dart
// lib/features/product/presentation/bloc/product_state.dart
import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product_entity.dart';

part 'product_state.freezed.dart';

@Freezed(equal: true)
class ProductState extends BaseDataStateCubit with _$ProductState {
  ProductState._();

  factory ProductState({
    @Default([]) List<ProductEntity> products,
    @Default(false) bool isLoading,
  }) = _ProductState;
}

@freezed
class ProductEvent extends BaseCubitEvent with _$ProductEvent {
  ProductEvent._();

  const factory ProductEvent.loadProducts() = LoadProducts;
  const factory ProductEvent.navigateToDetail(String productId) = NavigateToDetail;
}
```

**Rules:**
- ✅ Data State extends `BaseDataStateCubit`
- ✅ Event State extends `BaseCubitEvent`
- ✅ Clearly separate Data State and Event State
- ✅ Use domain entities in state
- ✅ **Update Data State:** use `emit(dataState.copyWith(...))` (variable/getter `dataState` is the current data state in Cubit). **Do NOT** use `state.copyWith(...)`.
- ✅ Create `index.dart` for exports

#### 4.2. Create BLoC

```dart
// lib/features/product/presentation/bloc/product_bloc.dart
import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_products_usecase.dart';
import 'product_state.dart';

@injectable
class ProductBloc extends BaseCubit<ProductState> {
  final GetProductsUseCase _getProductsUseCase;
  
  ProductBloc(this._getProductsUseCase) : super(const ProductState());
  
  Future<void> loadProducts() async {
    showLoading();
    
    final result = await _getProductsUseCase();
    
    hideLoading();
    
    result.when(
      success: (products) {
        emit(dataState.copyWith(products: products));
        emit(const ProductEvent.loadProducts());
      },
      failure: (failure) {
        showMessage(failure.message, type: MessageType.error);
      },
    );
  }
}
```

**Rules:**
- ✅ Extend `BaseCubit<ProductState>`
- ✅ Has `@injectable` annotation
- ✅ Use only Use Cases (do not call Repository directly)
- ✅ Use `showLoading()`, `hideLoading()`, `showMessage()`
- ✅ **Update Data State:** always use `emit(dataState.copyWith(...))`, **do NOT** use `emit(state.copyWith(...))` (BaseCubit provides getter `dataState`).
- ✅ Emit Data State and Event State separately
- ✅ Create `index.dart` for exports

#### 4.3. Create Page

```dart
// lib/features/product/presentation/pages/product_screen.dart
import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState
    extends BaseViewCubitState<ProductBloc, ProductState, ProductEvent, ProductScreen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilderDataState<ProductBloc, ProductState>(
        bloc: bloc,
        builder: (context, state) {
          if (state.products.isEmpty) {
            return const Center(child: Text('No products'));
          }
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
              );
            },
          );
        },
      ),
    );
  }

  @override
  ProductBloc initBloc() => getIt<ProductBloc>();

  @override
  void initData() {
    bloc?.loadProducts();
  }

  @override
  void initEventViewModel(BuildContext context, ProductEvent event) {
    event.when(
      loadProducts: () {
        // Handle load products event
      },
      navigateToDetail: (productId) {
        NavigatorUtils.instance.pushNamed('/product/$productId');
      },
    );
  }
}
```

**Rules:**
- ✅ Extend `BaseViewCubitState` or `BaseViewCubit`
- ✅ Use `BlocBuilderDataState` (do NOT use `BlocBuilder`)
- ✅ `initBloc()` returns from `getIt<>()`
- ✅ `initData()` for loading initial data
- ✅ `initEventViewModel()` for handling events

### Step 5: Register Dependencies

```dart
// lib/core/di/injection_container.dart
// This file is auto-generated after running build_runner
// Just ensure all classes have @injectable annotation
```

**Rules:**
- ✅ Run `flutter pub run build_runner build --delete-conflicting-outputs`
- ✅ Check `injection_container.config.dart` includes new dependencies

### Step 6: Update Routes

```dart
// lib/shared/routes/routes.dart
enum AppRoutes {
  // ... existing routes
  product; // Add new route

  Widget getPage(BuildContext context) {
    switch (this) {
      // ... existing cases
      case AppRoutes.product:
        return const ProductScreen();
    }
  }
}
```

---

## 🔍 Code Review Checklist

When reviewing code, verify:

### Domain Layer
- [ ] Entities are Pure Dart, no JSON annotations
- [ ] Repository interfaces in domain layer
- [ ] Use Cases have `@injectable` and inject repository interface
- [ ] No imports from data/presentation/shared (except core/error)

### Data Layer
- [ ] Models use `@JsonSerializable()` (not Freezed)
- [ ] Models have `toEntity()` extension
- [ ] Repository implementations have `@Injectable(as: Interface)`
- [ ] Repository implementations convert Model → Entity
- [ ] Only import from domain and core/error

### Presentation Layer
- [ ] BLoC extends `BaseCubit`
- [ ] BLoC has `@injectable` annotation
- [ ] BLoC uses only Use Cases
- [ ] State separates Data State and Event State
- [ ] Pages use `BlocBuilderDataState`
- [ ] Pages extend `BaseViewCubit` or `BaseViewCubitState`

### General
- [ ] `index.dart` in each folder
- [ ] Naming conventions followed
- [ ] No business logic in the wrong layer
- [ ] Error handling in place

---

## 📝 Naming Conventions

### Files
- Entities: `{name}_entity.dart` (e.g., `user_entity.dart`)
- Models: `{name}_model.dart` (e.g., `user_model.dart`)
- Repository Interface: `{name}_repository.dart` (e.g., `auth_repository.dart`)
- Repository Implementation: `{name}_repository_impl.dart` (e.g., `auth_repository_impl.dart`)
- Use Cases: `{action}_usecase.dart` (e.g., `login_usecase.dart`, `get_products_usecase.dart`)
- BLoCs: `{feature}_bloc.dart` (e.g., `auth_bloc.dart`)
- States: `{feature}_state.dart` (e.g., `auth_state.dart`)
- Pages: `{feature}_screen.dart` or `{feature}_page.dart` (e.g., `login_screen.dart`)

### Classes
- Entities: `{Name}Entity` (e.g., `UserEntity`)
- Models: `{Name}Model` (e.g., `UserModel`)
- Repository Interface: `{Name}Repository` (e.g., `AuthRepository`)
- Repository Implementation: `{Name}RepositoryImpl` (e.g., `AuthRepositoryImpl`)
- Use Cases: `{Action}UseCase` (e.g., `LoginUseCase`, `GetProductsUseCase`)
- BLoCs: `{Feature}Bloc` (e.g., `AuthBloc`)
- States: `{Feature}State`, `{Feature}Event` (e.g., `AuthState`, `AuthEvent`)

---

## 🚫 Common Mistakes to Avoid

### ❌ Mistake 1: Business Logic in BLoC

```dart
// ❌ WRONG
class AuthBloc extends BaseCubit<AuthState> {
  Future<void> login(String email, String password) async {
    if (!email.isValidEmail) { // ❌ Business logic in BLoC
      return;
    }
    // ...
  }
}

// ✅ CORRECT
class LoginUseCase {
  Future<Result<UserEntity>> call({required String email, ...}) async {
    if (!email.isValidEmail) { // ✅ Business logic in Use Case
      return Result.failure(Failure.validation(...));
    }
  }
}
```

### ❌ Mistake 2: Direct Access to Repository in BLoC

```dart
// ❌ WRONG
class AuthBloc extends BaseCubit<AuthState> {
  final AuthRepository _repository; // ❌ Direct access
  
  Future<void> login(...) async {
    final result = await _repository.login(...);
  }
}

// ✅ CORRECT
class AuthBloc extends BaseCubit<AuthState> {
  final LoginUseCase _loginUseCase; // ✅ Use Use Case
  
  Future<void> login(...) async {
    final result = await _loginUseCase(...);
  }
}
```

### ❌ Mistake 3: JSON Annotations in Entity

```dart
// ❌ WRONG
@JsonSerializable() // ❌
class UserEntity {
  // ...
}

// ✅ CORRECT
class UserEntity { // ✅ Pure Dart
  // ...
}
```

### ❌ Mistake 4: Using BlocBuilder Instead of BlocBuilderDataState

```dart
// ❌ WRONG
BlocBuilder<AuthBloc, AuthState>( // ❌
  builder: (context, state) => Text(state.user?.email ?? ''),
)

// ✅ CORRECT
BlocBuilderDataState<AuthBloc, AuthState>( // ✅
  bloc: bloc,
  builder: (context, state) => Text(state.user?.email ?? ''),
)
```

---

## 🔄 Development Workflow

1. **Create Feature Structure** → Create full folder structure
2. **Domain Layer First** → Entities → Repository Interfaces → Use Cases
3. **Data Layer** → Models → Data Sources → Repository Implementations
4. **Presentation Layer** → State → BLoC → Pages
5. **Register Dependencies** → Run build_runner
6. **Update Routes** → Add new route
7. **Test** → Verify feature works
8. **Code Review** → Review against checklist

---

## 📚 Memory Points

### Architecture Rules
- Domain Layer: Pure Dart, no dependencies
- Data Layer: Only depends on Domain
- Presentation Layer: Depends on Domain + Data
- Core/Shared: No feature dependencies

### Code Patterns
- Models: `@JsonSerializable()`, have `toEntity()` extension
- Entities: Pure Dart, no JSON annotations
- Use Cases: Business logic, inject repository interface
- BLoCs: Coordination only, inject use cases
- States: Separate Data State and Event State

### Best Practices
- Always use `BlocBuilderDataState`
- Always extend `BaseCubit` for BLoCs
- Always use Use Cases in BLoCs
- Always convert Model → Entity in Repository implementations
- Always have `index.dart` in each folder

---

## 📖 Reference Documentation

- `REQUIREMENTS.md` - Mandatory requirements to follow
- `CLEAN_ARCHITECTURE_LAYERS.md` - Layer details
- `FORM_VALIDATION_GUIDE.md` - Validation guide
- `README.md` - Project overview

---

**Note:** Always follow these rules when developing new features to ensure consistency and maintainability of the codebase.
