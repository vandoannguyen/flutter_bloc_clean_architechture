#!/bin/bash
if [ -z "$1" ]; then
  echo "Please provide module name (feature)."
  exit 1
fi

feature_name=$1
# Convert string from lowercase_with_underscores to UpperCamelCase
class_name=$(echo "$feature_name" | awk -F'_' '{for(i=1;i<=NF;i++) { $i=toupper(substr($i,1,1)) substr($i,2) }} 1' OFS='')

# Create Clean Architecture Folder Structure for Flutter
echo "Create folder structure for module $feature_name ..."

# Create folder for page
mkdir -p lib/view/${feature_name}

# Create a basic file in the 'presentation' folder
echo "import 'package:base_bloc_module/index.dart';

import 'package:base_flutter_bloc/bloc/${feature_name}/${feature_name}_cubit.dart';
import 'package:base_flutter_bloc/bloc/${feature_name}/${feature_name}_state.dart';
import 'package:flutter/material.dart';

class ${class_name}Screen extends StatefulWidget {
  const ${class_name}Screen({super.key});

  @override
  State<${class_name}Screen> createState() => _${class_name}ScreenState();
}

class _${class_name}ScreenState extends BaseViewCubitState<
    ${class_name}Bloc,
    ${class_name}State,
    ${class_name}Event,
    ${class_name}Screen> {
  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold();
  }

  @override
  ${class_name}Bloc initBloc() {
    return getIt<${class_name}Bloc>();
  }

  @override
  void initData() {
      WidgetsBinding.instance.addPostFrameCallback((_){

      });
  }

  @override
  void initEventViewModel(BuildContext context, ${class_name}Event state) {}
}
" > lib/view/${feature_name}/${feature_name}_screen.dart

# Create a directory for cubit
mkdir -p lib/bloc/${feature_name}

# Create base file in 'cubit' folder
echo "import 'package:base_bloc_module/base/cubit/base_cubit.dart';

import '${feature_name}_state.dart';

class ${class_name}Bloc extends BaseCubit<${class_name}State> {
  ${class_name}Bloc() : super(${class_name}State());
}
" > lib/bloc/${feature_name}/${feature_name}_cubit.dart


echo "import 'package:base_bloc_module/index.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part '${feature_name}_state.freezed.dart';

@Freezed(equal: true)
class ${class_name}State extends BaseDataStateCubit
    with _\$${class_name}State {
  factory ${class_name}State() = _${class_name}State;
}

@freezed
class ${class_name}Event extends BaseCubitEvent with _\$${class_name}Event {
  factory ${class_name}Event.getData() = GetData;
}
" > lib/bloc/${feature_name}/${feature_name}_state.dart
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
## Add export to usecase index file
#echo "export 'src/${feature_name}_usecase.dart';" >> lib/features/domain/usecases/usecase.dart
#
## Add page name to route name file
#page_name=$(echo "$feature_name" | awk -F'_' '{for(i=1;i<=NF;i++) { if(i==1) { printf $i } else { printf toupper(substr($i,1,1)) substr($i,2) } } print ""}')
#file_path="lib/features/app/routes/src/routes_name.dart"
#content="  static const String $page_name = '/${page_name}';"
#  # Check if file exists
#if [ ! -f "$file_path" ]; then
#  echo "File '$file_path' does not exist. Please check again."
#  exit 1
#fi
#  # Count the number of lines in the file
#line_count=$(wc -l < "$file_path")
#  # Check if file has less than 2 lines
#if [ "$line_count" -lt 2 ]; then
#  echo "File '$file_path' must have at least 2 lines to insert content."
#  exit 1
#fi
#  # Insert content before line (file length - 1)
#insert_line=$((line_count - 1))
#  # Use sed to insert content into the calculated line
#sed -i "${insert_line}i $content" "$file_path"
#
#echo "All files and directories for module $feature_name have been successfully created."
#
## Open module folder in VSCode (if VSCode is installed)
#code lib/features/presentation/pages/${feature_name}_page/${feature_name}_page.dart
