# 📁 Optimal Folder Structure

## 🎯 Proposed Structure

<!--
This document describes the optimal folder structure for a Flutter project using Clean Architecture and BLoC pattern.
The structure is feature-based, making it easy to scale and maintain.
-->

```
lib/
├── core/                              # Core functionality (shared across features)
│   ├── error/                         # Error handling
│   │   ├── exceptions/                # Exception classes
│   │   │   ├── business_exception.dart
│   │   │   ├── network_exception.dart
│   │   │   └── server_exception.dart
│   │   ├── failures/                  # Failure types (Result pattern)
│   │   │   └── failure.dart
│   │   └── result.dart                # Result/Either pattern
│   │
│   ├── network/                       # Network configuration
│   │   ├── dio_client.dart
│   │   ├── interceptors/              # Dio interceptors
│   │   │   ├── auth_interceptor.dart
│   │   │   └── logging_interceptor.dart
│   │   ├── endpoints.dart             # API endpoints
│   │   └── multipart_file_extended.dart
│   │
│   ├── storage/                       # Local storage
│   │   ├── secure_storage.dart        # Secure storage (if needed)
│   │   └── shared_preferences.dart    # SharedPreferences wrapper
│   │
│   ├── bloc/                          # Base BLoC classes
│   │   ├── enhanced_base_cubit.dart
│   │   ├── state_helpers.dart
│   │   └── status_state_mixin.dart
│   │
│   ├── utils/                         # Utilities
│   │   ├── validators/                # Form validators
│   │   │   └── validators.dart
│   │   ├── extensions/                # Extensions
│   │   │   ├── build_context_extensions.dart
│   │   │   ├── string_extensions.dart
│   │   │   └── datetime_extensions.dart
│   │   ├── debouncer.dart
│   │   ├── logger.dart
│   │   └── function.dart
│   │
│   ├── constants/                     # App-wide constants
│   │   └── app_constants.dart
│   │
│   └── di/                            # Dependency Injection
│       ├── injection_container.dart
│       ├── injection_container.config.dart
│       └── modules.dart
│
├── features/                          # Feature-based structure
│   ├── auth/                          # Authentication feature
│   │   ├── data/
│   │   │   ├── datasources/           # Data sources
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/                # Data models (JSON serializable)
│   │   │   │   ├── user_model.dart
│   │   │   │   └── token_model.dart
│   │   │   └── repositories/          # Repository implementations
│   │   │       └── auth_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/              # Domain entities (pure Dart)
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/          # Repository interfaces
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/              # Business logic
│   │   │       ├── login_usecase.dart
│   │   │       ├── logout_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                  # BLoC/Cubit
│   │       │   ├── auth_bloc.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/                 # Screens
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       └── widgets/               # Feature-specific widgets
│   │           ├── login_form.dart
│   │           └── password_field.dart
│   │
│   ├── home/                          # Home feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   └── profile/                       # Profile feature
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/                             # Shared across features
│   ├── widgets/                       # Common widgets
│   │   ├── loading_widget.dart
│   │   ├── error_widget.dart
│   │   └── empty_state_widget.dart
│   │
│   ├── theme/                         # Theming
│   │   ├── theme_data.dart
│   │   ├── style.dart
│   │   └── size_config.dart
│   │
│   ├── routes/                        # Navigation
│   │   ├── routes.dart
│   │   ├── route_names.dart
│   │   └── app_router.dart
│   │
│   └── utils/                         # Shared utilities
│       ├── navigate_utils.dart
│       ├── auth_utils.dart
│       ├── share_preference_utils.dart
│       └── app_route_tracking.dart
│
├── gen/                                # Generated files (do not edit)
│   ├── assets.gen.dart
│   ├── fonts.gen.dart
│   └── intl/
│
├── translations/                      # Localization files
│   └── intl_en.arb
│
├── main.dart                          # App entry point
├── my_app.dart                        # Root widget
└── firebase_options.dart              # Firebase configuration
```

---

## 📋 Migration Plan

<!--
Migration should be done in phases to ensure stability and easy rollback if needed.
Each phase should be tested before moving to the next.
-->

### Phase 1: Create Core Structure
<!-- Core infrastructure that all features depend on -->
1. ✅ Create `core/` folder structure
2. ✅ Move network files to `core/network/`
3. ✅ Move error files to `core/error/`
4. ✅ Move utils to `core/utils/`
5. ✅ Move constants to `core/constants/`
6. ✅ Move DI to `core/di/`

### Phase 2: Create Features Structure
<!-- Feature-based organization for better scalability -->
1. ✅ Create `features/` folder
2. ✅ Refactor `auth` feature (login, register)
3. ✅ Refactor `home` feature
4. ✅ Create feature templates

### Phase 3: Create Shared Structure
<!-- Shared code used across multiple features -->
1. ✅ Create `shared/` folder
2. ✅ Move common widgets
3. ✅ Move theme files
4. ✅ Move routes
5. ✅ Move shared utils

### Phase 4: Clean Up
<!-- Final cleanup after verification -->
1. ✅ Remove old folders
2. ✅ Update imports
3. ✅ Update documentation

---

## 🎯 Benefits

1. **Feature-based**: Easy to find and maintain code
2. **Clean Architecture**: Clear separation of layers
3. **Scalable**: Easy to add new features
4. **Testable**: Each layer can be tested independently
5. **Reusable**: Core and shared code can be reused

---

## 📝 Naming Conventions

### Files:
- **BLoC**: `{feature}_bloc.dart`, `{feature}_state.dart`
- **Pages**: `{feature}_page.dart`
- **Widgets**: `{feature}_{widget_name}_widget.dart`
- **Use Cases**: `{action}_usecase.dart`
- **Repositories**: `{feature}_repository.dart`, `{feature}_repository_impl.dart`
- **Models**: `{entity}_model.dart`
- **Entities**: `{entity}_entity.dart`

### Folders:
- Use lowercase with underscores: `auth`, `user_profile`
- Keep it simple and descriptive

---

## 🔄 Import Paths

### Before:
```dart
import 'package:base_flutter_bloc/bloc/login/login_bloc.dart';
import 'package:base_flutter_bloc/view/login/login_screen.dart';
```

### After:
```dart
import 'package:base_flutter_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_flutter_bloc/features/auth/presentation/pages/login_page.dart';
```

---

## 📚 Feature Template

When creating a new feature, use this structure:

```
features/{feature_name}/
├── data/
│   ├── datasources/
│   │   ├── {feature}_remote_datasource.dart
│   │   └── {feature}_local_datasource.dart
│   ├── models/
│   │   └── {entity}_model.dart
│   └── repositories/
│       └── {feature}_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── {entity}_entity.dart
│   ├── repositories/
│   │   └── {feature}_repository.dart
│   └── usecases/
│       └── {action}_usecase.dart
│
└── presentation/
    ├── bloc/
    │   ├── {feature}_bloc.dart
    │   └── {feature}_state.dart
    ├── pages/
    │   └── {feature}_page.dart
    └── widgets/
        └── {feature}_widget.dart
```

---

## 🚀 Next Steps

1. Review the new structure
2. Start migrating features one by one
3. Update imports as you go
4. Test thoroughly after each migration
5. Update documentation
