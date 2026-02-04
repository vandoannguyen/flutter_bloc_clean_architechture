# 📝 Form Validation in Clean Architecture

## 🎯 Principles

In Clean Architecture, validation is split into **2 types**:

### 1. **Input Validation** (Format, Required Fields)
- **Location**: **Presentation Layer** (BLoC or Form Widget)
- **Purpose**: Check format and required fields before submitting
- **Examples**: Email format, password length, required fields

### 2. **Business Validation** (Business Rules)
- **Location**: **Domain Layer** (Use Cases)
- **Purpose**: Enforce business rules and logic
- **Examples**: Email already exists, password meets policy, sufficient balance for payment

---

## 📐 Architecture

```
┌─────────────────────────────────────┐
│   Presentation Layer (UI)          │
│   ┌─────────────────────────────┐  │
│   │ Form Widget                  │  │
│   │ - Required fields check      │  │
│   │ - Format validation          │  │
│   └─────────────────────────────┘  │
│   ┌─────────────────────────────┐  │
│   │ BLoC                         │  │
│   │ - Input validation           │  │
│   │ - Format check               │  │
│   └─────────────────────────────┘  │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│   Domain Layer (Business Logic)     │
│   ┌─────────────────────────────┐  │
│   │ Use Case                     │  │
│   │ - Business validation       │  │
│   │ - Business rules             │  │
│   └─────────────────────────────┘  │
└─────────────────────────────────────┘
              ↓
┌─────────────────────────────────────┐
│   Data Layer (API)                 │
│   - No validation                   │
└─────────────────────────────────────┘
```

---

## 💡 Example: Registration Form

### Scenario: Registration form with fields:
- Email (required, format)
- Password (required, min 8 chars)
- Confirm Password (required, must match password)
- Name (required, min 2 chars)

---

## ✅ Approach 1: Validation in BLoC (Recommended)

### Presentation Layer - BLoC

```dart
// lib/features/auth/presentation/bloc/register_bloc.dart
import 'package:base_bloc_module/index.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/extensions/string_extensions.dart';
import '../../domain/usecases/register_usecase.dart';
import 'register_state.dart';

@injectable
class RegisterBloc extends BaseCubit<RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc(this._registerUseCase) : super(const RegisterState());

  /// Validates form input.
  /// 
  /// Returns null if valid, error message if invalid.
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }
    if (!email.isValidEmail) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }
    if (name.length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  /// Validates all form fields.
  /// 
  /// Returns true if all fields are valid, false otherwise.
  bool _validateForm({
    required String? email,
    required String? password,
    required String? confirmPassword,
    required String? name,
  }) {
    final emailError = _validateEmail(email);
    final passwordError = _validatePassword(password);
    final confirmPasswordError = _validateConfirmPassword(password, confirmPassword);
    final nameError = _validateName(name);

    emit(dataState.copyWith(
      emailError: emailError,
      passwordError: passwordError,
      confirmPasswordError: confirmPasswordError,
      nameError: nameError,
      isValid: emailError == null &&
          passwordError == null &&
          confirmPasswordError == null &&
          nameError == null,
    ));

    return state.isValid;
  }

  /// Updates email field.
  void updateEmail(String email) {
    final error = _validateEmail(email);
    emit(dataState.copyWith(
      email: email,
      emailError: error,
    ));
    _checkFormValidity();
  }

  /// Updates password field.
  void updatePassword(String password) {
    final error = _validatePassword(password);
    emit(dataState.copyWith(
      password: password,
      passwordError: error,
    ));
    _checkFormValidity();
  }

  /// Updates confirm password field.
  void updateConfirmPassword(String confirmPassword) {
    final error = _validateConfirmPassword(state.password, confirmPassword);
    emit(dataState.copyWith(
      confirmPassword: confirmPassword,
      confirmPasswordError: error,
    ));
    _checkFormValidity();
  }

  /// Updates name field.
  void updateName(String name) {
    final error = _validateName(name);
    emit(dataState.copyWith(
      name: name,
      nameError: error,
    ));
    _checkFormValidity();
  }

  /// Checks overall form validity.
  void _checkFormValidity() {
    emit(dataState.copyWith(
      isValid: state.emailError == null &&
          state.passwordError == null &&
          state.confirmPasswordError == null &&
          state.nameError == null &&
          state.email != null &&
          state.password != null &&
          state.confirmPassword != null &&
          state.name != null,
    ));
  }

  /// Submits the registration form.
  Future<void> submit() async {
    // Validate all fields
    if (!_validateForm(
      email: state.email,
      password: state.password,
      confirmPassword: state.confirmPassword,
      name: state.name,
    )) {
      showMessage('Please fix the errors in the form', type: MessageType.waring);
      return;
    }

    showLoading();

    final result = await _registerUseCase(
      email: state.email!,
      password: state.password!,
      name: state.name!,
    );

    hideLoading();

    result.when(
      success: (user) {
        emit(dataState.copyWith(isSuccess: true));
        emit(const RegisterEvent.navigateToHome());
      },
      failure: (failure) {
        emit(dataState.copyWith(errorMessage: failure.message));
        showMessage(failure.message, type: MessageType.error);
      },
    );
  }
}
```

### Presentation Layer - State

```dart
// lib/features/auth/presentation/bloc/register_state.dart
import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_state.freezed.dart';

@Freezed(equal: true)
class RegisterState extends BaseDataStateCubit with _$RegisterState {
  RegisterState._();

  factory RegisterState({
    String? email,
    String? password,
    String? confirmPassword,
    String? name,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    String? nameError,
    @Default(false) bool isValid,
    @Default(false) bool isSuccess,
    String? errorMessage,
  }) = _RegisterState;
}

@freezed
class RegisterEvent extends BaseCubitEvent with _$RegisterEvent {
  RegisterEvent._();

  const factory RegisterEvent.navigateToHome() = NavigateToHome;
}
```

### Presentation Layer - UI

```dart
// lib/features/auth/presentation/pages/register_screen.dart
import 'package:base_bloc_module/index.dart';
import 'package:flutter/material.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState
    extends BaseViewCubitState<RegisterBloc, RegisterState, RegisterEvent, RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: BlocBuilderDataState<RegisterBloc, RegisterState>(
        bloc: bloc,
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: state.emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => bloc?.updateEmail(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: state.passwordError,
                    ),
                    obscureText: true,
                    onChanged: (value) => bloc?.updatePassword(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText: state.confirmPasswordError,
                    ),
                    obscureText: true,
                    onChanged: (value) => bloc?.updateConfirmPassword(value),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      errorText: state.nameError,
                    ),
                    onChanged: (value) => bloc?.updateName(value),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: state.isValid ? bloc?.submit : null,
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  RegisterBloc initBloc() => getIt<RegisterBloc>();

  @override
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, RegisterEvent state) {
    state.when(
      navigateToHome: () {
        // Navigate to home
      },
    );
  }
}
```

### Domain Layer - Use Case (Business Validation)

```dart
// lib/features/auth/domain/usecases/register_usecase.dart
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/utils/extensions/string_extensions.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

@injectable
class RegisterUseCase {
  final AuthRepository _repository;

  RegisterUseCase(this._repository);

  /// Executes the register use case.
  /// 
  /// This includes business validation (e.g., email already exists).
  /// Input validation (format, required) should be done in BLoC.
  Future<Result<UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) async {
    // Business validation: Check if email already exists
    final checkEmailResult = await _repository.checkEmailExists(email);
    
    return checkEmailResult.when(
      success: (exists) {
        if (exists) {
          return Result.failure(
            const Failure.validation(
              message: 'Email already exists',
            ),
          );
        }
        
        // Business validation: Password strength policy
        if (!_isPasswordStrongEnough(password)) {
          return Result.failure(
            const Failure.validation(
              message: 'Password does not meet security requirements',
            ),
          );
        }
        
        // Call repository
        return _repository.register(
          email: email,
          password: password,
          name: name,
        );
      },
      failure: (failure) => Result.failure(failure),
    );
  }

  /// Business rule: Check if password is strong enough.
  /// 
  /// This is a business rule, not just format validation.
  bool _isPasswordStrongEnough(String password) {
    // Business rule: Must contain uppercase, lowercase, number, special char
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasLower = password.contains(RegExp(r'[a-z]'));
    final hasNumber = password.contains(RegExp(r'[0-9]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    return hasUpper && hasLower && hasNumber && hasSpecial;
  }
}
```

---

## ✅ Approach 2: Validation in Form Widget (Alternative)

If you prefer validation directly in the Form widget:

```dart
// lib/features/auth/presentation/pages/register_screen.dart
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!value.isValidEmail) {
      return 'Invalid email format';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, call BLoC
      bloc?.register(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: _validateEmail,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: _passwordController,
            validator: _validatePassword,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }
}
```

---

## 📋 Summary

| Validation Type | Location | Examples |
|----------------|--------|-------|
| **Input Validation** | **Presentation Layer** (BLoC or Form Widget) | Email format, required fields, password length |
| **Business Validation** | **Domain Layer** (Use Cases) | Email already exists, password strength policy, sufficient balance |

### ✅ Best Practices

1. **Input Validation** → **BLoC** (Recommended)
   - Easier to test
   - Logic separated from UI
   - Validation logic can be reused

2. **Business Validation** → **Use Cases**
   - Business rules are independent of UI
   - Can be tested in isolation
   - Complies with Clean Architecture

3. **No validation in Data Layer**
   - Data layer only serializes/deserializes
   - Validation is business logic, not a data concern

---

## 🎯 Recommendation for This Project

**Use Approach 1 (Validation in BLoC)** because:
- ✅ Logic separated from UI
- ✅ Easier to test
- ✅ Validation logic can be reused
- ✅ Fits BLoC pattern
- ✅ Better state management

**Business validation** (email exists, password policy) → **Use Cases**

**Input validation** (format, required) → **BLoC**
