# Core Module

<!--
The Core module contains infrastructure and base functionality that is shared across all features.
This module should be feature-agnostic and contain no business logic.
-->

This folder contains core functionality shared across all features.

## Structure

<!--
Each subfolder in core has a specific purpose:
- error: Error handling patterns and exceptions
- network: HTTP client and network configuration
- storage: Local storage abstractions
- bloc: Base BLoC classes and state management helpers
- utils: Utility functions, extensions, and validators
- constants: Application-wide constants
- di: Dependency injection configuration
-->

- **error/**: Error handling (Result pattern, Failures, Exceptions)
- **network/**: Network configuration (Dio client, interceptors, endpoints)
- **storage/**: Local storage utilities
- **bloc/**: Base BLoC classes and helpers
- **utils/**: Utility functions, extensions, validators
- **constants/**: App-wide constants
- **di/**: Dependency Injection configuration

## Usage

Import core modules like this:

```dart
import 'package:base_flutter_bloc/core/error/result.dart';
import 'package:base_flutter_bloc/core/utils/extensions/build_context_extensions.dart';
import 'package:base_flutter_bloc/core/constants/app_constants.dart';
```

## Guidelines

<!--
When adding code to core, ensure it follows these principles:
- Feature-agnostic: Should work with any feature
- No business logic: Only infrastructure and utilities
- Reusable: Can be used by multiple features
- No feature dependencies: Should not import from features folder
-->

- ✅ Core code should be feature-agnostic
- ✅ No business logic in core
- ✅ Reusable across all features
- ❌ Don't import feature-specific code here
