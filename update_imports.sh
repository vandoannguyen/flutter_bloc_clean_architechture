#!/bin/bash

# Script to update imports after folder structure migration
# Usage: ./update_imports.sh

echo "🔄 Updating imports..."

# Find all Dart files
find lib -name "*.dart" -type f | while read file; do
    echo "Processing: $file"
    
    # Update core imports
    sed -i '' \
        -e 's|package:base_flutter_bloc/api/|package:base_flutter_bloc/core/network/|g' \
        -e 's|package:base_flutter_bloc/exception/|package:base_flutter_bloc/core/error/exceptions/|g' \
        -e 's|package:base_flutter_bloc/di/|package:base_flutter_bloc/core/di/|g' \
        -e 's|package:base_flutter_bloc/common/logger/|package:base_flutter_bloc/core/utils/|g' \
        "$file"
    
    # Update shared imports
    sed -i '' \
        -e 's|package:base_flutter_bloc/utils/|package:base_flutter_bloc/shared/utils/|g' \
        -e 's|package:base_flutter_bloc/theme/|package:base_flutter_bloc/shared/theme/|g' \
        -e 's|package:base_flutter_bloc/routes/|package:base_flutter_bloc/shared/routes/|g' \
        -e 's|package:base_flutter_bloc/widgets/|package:base_flutter_bloc/shared/widgets/|g' \
        "$file"
    
    # Update feature imports - Auth
    sed -i '' \
        -e 's|package:base_flutter_bloc/bloc/login/|package:base_flutter_bloc/features/auth/presentation/bloc/|g' \
        -e 's|package:base_flutter_bloc/bloc/register_account/|package:base_flutter_bloc/features/auth/presentation/bloc/|g' \
        -e 's|package:base_flutter_bloc/view/login/|package:base_flutter_bloc/features/auth/presentation/pages/|g' \
        -e 's|package:base_flutter_bloc/view/register_account/|package:base_flutter_bloc/features/auth/presentation/pages/|g' \
        "$file"
    
    # Update feature imports - Home
    sed -i '' \
        -e 's|package:base_flutter_bloc/bloc/home/|package:base_flutter_bloc/features/home/presentation/bloc/|g' \
        -e 's|package:base_flutter_bloc/view/home/|package:base_flutter_bloc/features/home/presentation/pages/|g' \
        "$file"
    
    # Update model imports
    sed -i '' \
        -e 's|package:base_flutter_bloc/model/entity/|package:base_flutter_bloc/features/auth/domain/entities/|g' \
        -e 's|package:base_flutter_bloc/model/network/|package:base_flutter_bloc/features/auth/data/datasources/|g' \
        -e 's|package:base_flutter_bloc/model/local/|package:base_flutter_bloc/features/auth/data/datasources/|g' \
        -e 's|package:base_flutter_bloc/model/repository/|package:base_flutter_bloc/features/auth/data/repositories/|g' \
        -e 's|package:base_flutter_bloc/model/request/|package:base_flutter_bloc/features/auth/data/models/|g' \
        "$file"
done

echo "✅ Import update completed!"
echo "⚠️  Please review the changes and test your app before committing."
