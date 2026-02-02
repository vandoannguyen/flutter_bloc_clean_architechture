# Shared Module

<!--
The Shared module contains code that is used by multiple features but is not core infrastructure.
This includes UI components, themes, routes, and shared utilities.
-->

This folder contains code shared across multiple features.

## Structure

<!--
Shared module contains:
- widgets: Reusable UI components
- theme: App-wide theming (colors, styles)
- routes: Navigation configuration
- utils: Shared utility functions
-->

- **widgets/**: Common widgets used by multiple features
- **theme/**: Theming configuration (colors, text styles, etc.)
- **routes/**: Navigation configuration
- **utils/**: Shared utility functions

## Usage

Import shared modules like this:

```dart
import 'package:base_flutter_bloc/shared/widgets/loading_widget.dart';
import 'package:base_flutter_bloc/shared/theme/theme_data.dart';
import 'package:base_flutter_bloc/shared/routes/routes.dart';
```

## Guidelines

- ✅ Code used by 2+ features
- ✅ Common UI components
- ✅ Shared utilities
- ❌ Don't put feature-specific code here
- ❌ Don't put business logic here

## Difference from Core

<!--
Key differences:
- Core: Infrastructure, no UI dependencies
- Shared: UI components and theming, has Flutter dependencies
-->

- **Core**: Infrastructure, utilities, base classes (no UI)
- **Shared**: UI components, themes, routes (has UI)
