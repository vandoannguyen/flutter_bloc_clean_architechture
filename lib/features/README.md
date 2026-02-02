# Features Module

<!--
The Features module follows Clean Architecture principles with clear separation of concerns.
Each feature is independent and contains its own data, domain, and presentation layers.
-->

This folder contains feature-based modules following Clean Architecture.

## Structure

<!--
Clean Architecture layers:
- data: External data sources (API, local storage)
- domain: Business logic and entities (pure Dart, no dependencies)
- presentation: UI layer (BLoC, pages, widgets)
-->

Each feature follows this structure:

```
{feature_name}/
├── data/              # Data layer
│   ├── datasources/   # Remote & Local data sources
│   ├── models/        # Data models (JSON serializable)
│   └── repositories/  # Repository implementations
│
├── domain/            # Domain layer (business logic)
│   ├── entities/      # Domain entities (pure Dart)
│   ├── repositories/  # Repository interfaces
│   └── usecases/      # Business logic use cases
│
└── presentation/      # Presentation layer (UI)
    ├── bloc/          # BLoC/Cubit
    ├── pages/         # Screens
    └── widgets/       # Feature-specific widgets
```

## Creating a New Feature

<!--
Follow this order when creating a new feature:
1. Domain layer first (entities, repository interfaces)
2. Data layer (models, data sources, repository implementations)
3. Use cases (business logic)
4. Presentation layer (BLoC, pages, widgets)
-->

1. Create the folder structure:
   ```bash
   mkdir -p lib/features/{feature_name}/{data/{datasources,models,repositories},domain/{entities,repositories,usecases},presentation/{bloc,pages,widgets}}
   ```

2. Start with domain layer (entities, repositories interfaces)
3. Implement data layer (models, data sources, repository implementations)
4. Create use cases in domain layer
5. Build presentation layer (BLoC, pages, widgets)

## Guidelines

- ✅ Each feature is independent
- ✅ Features can depend on core and shared
- ✅ Features should NOT depend on other features
- ✅ Use dependency injection for dependencies
- ❌ Don't create circular dependencies

## Example Features

- **auth**: Authentication (login, register, logout)
- **home**: Home screen with dashboard
- **profile**: User profile management
