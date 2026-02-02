# 🔄 Migration Guide: Old Structure → New Structure

## 📋 Overview

This guide helps you migrate from the old folder structure to the new feature-based Clean Architecture structure.

---

## 🗺️ File Mapping

### Core Files

| Old Path | New Path |
|----------|----------|
| `lib/api/*` | `lib/core/network/*` |
| `lib/exception/*` | `lib/core/error/exceptions/*` |
| `lib/common/logger/*` | `lib/core/utils/` |
| `lib/di/*` | `lib/core/di/*` |
| `lib/utils/*` | `lib/shared/utils/*` |
| `lib/theme/*` | `lib/shared/theme/*` |
| `lib/routes/*` | `lib/shared/routes/*` |
| `lib/widgets/*` | `lib/shared/widgets/*` |

### Auth Feature

| Old Path | New Path |
|----------|----------|
| `lib/view/login/*` | `lib/features/auth/presentation/pages/` |
| `lib/view/register_account/*` | `lib/features/auth/presentation/pages/` |
| `lib/bloc/login/*` | `lib/features/auth/presentation/bloc/` |
| `lib/bloc/register_account/*` | `lib/features/auth/presentation/bloc/` |
| `lib/model/entity/*` | `lib/features/auth/domain/entities/` |
| `lib/model/network/*` | `lib/features/auth/data/datasources/` |
| `lib/model/local/*` | `lib/features/auth/data/datasources/` |
| `lib/model/repository/*` | `lib/features/auth/data/repositories/` |
| `lib/model/request/*` | `lib/features/auth/data/models/` |

### Home Feature

| Old Path | New Path |
|----------|----------|
| `lib/view/home/*` | `lib/features/home/presentation/pages/` |
| `lib/bloc/home/*` | `lib/features/home/presentation/bloc/` |

---

## 🔧 Import Updates

### Before:
```dart
import 'package:base_flutter_bloc/bloc/login/login_bloc.dart';
import 'package:base_flutter_bloc/view/login/login_screen.dart';
import 'package:base_flutter_bloc/api/dio_client.dart';
import 'package:base_flutter_bloc/utils/navigate_utils.dart';
import 'package:base_flutter_bloc/theme/theme_data.dart';
```

### After:
```dart
import 'package:base_flutter_bloc/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:base_flutter_bloc/features/auth/presentation/pages/login_page.dart';
import 'package:base_flutter_bloc/core/network/dio_client.dart';
import 'package:base_flutter_bloc/shared/utils/navigate_utils.dart';
import 'package:base_flutter_bloc/shared/theme/theme_data.dart';
```

---

## 📝 Step-by-Step Migration

### Step 1: Update Core Imports

Find and replace in all files:

```bash
# Network
lib/api/ → lib/core/network/

# Error handling
lib/exception/ → lib/core/error/exceptions/
lib/core/error/ → lib/core/error/

# Utils
lib/common/logger/ → lib/core/utils/
lib/utils/ → lib/shared/utils/

# DI
lib/di/ → lib/core/di/
```

### Step 2: Update Feature Imports

```bash
# Auth feature
lib/view/login/ → lib/features/auth/presentation/pages/
lib/bloc/login/ → lib/features/auth/presentation/bloc/
lib/model/entity/ → lib/features/auth/domain/entities/
lib/model/network/ → lib/features/auth/data/datasources/
lib/model/repository/ → lib/features/auth/data/repositories/
lib/model/request/ → lib/features/auth/data/models/

# Home feature
lib/view/home/ → lib/features/home/presentation/pages/
lib/bloc/home/ → lib/features/home/presentation/bloc/
```

### Step 3: Update Shared Imports

```bash
lib/theme/ → lib/shared/theme/
lib/routes/ → lib/shared/routes/
lib/widgets/ → lib/shared/widgets/
```

### Step 4: Update pubspec.yaml (if needed)

If you have path dependencies, update them:

```yaml
# Before
dependencies:
  base_flutter_bloc:
    path: ./lib

# After (no change needed, but verify imports)
```

---

## 🛠️ Automated Migration Script

Create a script to help with migration:

```bash
#!/bin/bash
# migrate_imports.sh

# Replace imports in all Dart files
find lib -name "*.dart" -type f -exec sed -i '' \
  -e 's|package:base_flutter_bloc/api/|package:base_flutter_bloc/core/network/|g' \
  -e 's|package:base_flutter_bloc/exception/|package:base_flutter_bloc/core/error/exceptions/|g' \
  -e 's|package:base_flutter_bloc/di/|package:base_flutter_bloc/core/di/|g' \
  -e 's|package:base_flutter_bloc/utils/|package:base_flutter_bloc/shared/utils/|g' \
  -e 's|package:base_flutter_bloc/theme/|package:base_flutter_bloc/shared/theme/|g' \
  -e 's|package:base_flutter_bloc/routes/|package:base_flutter_bloc/shared/routes/|g' \
  -e 's|package:base_flutter_bloc/widgets/|package:base_flutter_bloc/shared/widgets/|g' \
  -e 's|package:base_flutter_bloc/bloc/login/|package:base_flutter_bloc/features/auth/presentation/bloc/|g' \
  -e 's|package:base_flutter_bloc/view/login/|package:base_flutter_bloc/features/auth/presentation/pages/|g' \
  {} \;
```

---

## ✅ Verification Checklist

After migration, verify:

- [ ] All imports updated
- [ ] App compiles without errors
- [ ] All features work correctly
- [ ] Tests pass
- [ ] No broken references
- [ ] Old folders removed (after verification)

---

## 🚨 Common Issues

### Issue 1: Circular Dependencies
**Problem**: Feature A imports Feature B, Feature B imports Feature A

**Solution**: 
- Move shared code to `shared/` or `core/`
- Use dependency injection
- Create interfaces in domain layer

### Issue 2: Missing Imports
**Problem**: Files can't find their dependencies

**Solution**:
- Check import paths
- Verify files were moved correctly
- Update pubspec.yaml if needed

### Issue 3: Old Folders Still Exist
**Problem**: Old folders still have files

**Solution**:
- Check for remaining files
- Move or delete them
- Update any remaining imports

---

## 📚 Next Steps

1. ✅ Complete migration
2. ✅ Update all imports
3. ✅ Test the application
4. ✅ Remove old folders
5. ✅ Update documentation
6. ✅ Create feature templates

---

## 💡 Tips

- Migrate one feature at a time
- Test after each migration step
- Use IDE's "Find and Replace" feature
- Keep a backup before migration
- Commit after each successful step
