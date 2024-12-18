#!/bin/bash

# Kiểm tra nếu có tên module được truyền vào
if [ -z "$1" ]; then
  echo "Vui lòng cung cấp tên module (feature)."
  exit 1
fi

# Tên module/feature được truyền vào
feature_name=$1
# Chuyển đổi chuỗi từ lowercase_with_underscores sang UpperCamelCase
class_name=$(echo "$feature_name" | awk -F'_' '{for(i=1;i<=NF;i++) { $i=toupper(substr($i,1,1)) substr($i,2) }} 1' OFS='')

# Tạo cấu trúc thư mục Clean Architecture cho Flutter
echo "Tạo cấu trúc thư mục cho module $feature_name ..."

# Tạo thư mục cho page
mkdir -p lib/view/${feature_name}

# Tạo file cơ bản trong thư mục 'presentation'
echo "import 'package:base_bloc_module/index.dart';
import 'package:base_flutter_bloc/di/injection_container.dart';
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
  void initData() {}

  @override
  void initEventViewModel(BuildContext context, ${class_name}Event state) {}
}
" > lib/view/${feature_name}/${feature_name}_screen.dart

# Tạo thư mục cho cubit
mkdir -p lib/bloc/${feature_name}

# Tạo file cơ bản trong thư mục 'cubit'
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
  const factory ${class_name}Event.getData() = GetData;
}
" > lib/bloc/${feature_name}/${feature_name}_state.dart
fvm flutter packages pub run build_runner build --delete-conflicting-outputs
## Thêm export vào index file của usecase
#echo "export 'src/${feature_name}_usecase.dart';" >> lib/features/domain/usecases/usecase.dart
#
## Thêm page name vào file route name
#page_name=$(echo "$feature_name" | awk -F'_' '{for(i=1;i<=NF;i++) { if(i==1) { printf $i } else { printf toupper(substr($i,1,1)) substr($i,2) } } print ""}')
#file_path="lib/features/app/routes/src/routes_name.dart"
#content="  static const String $page_name = '/${page_name}';"
#  # Kiểm tra nếu file tồn tại
#if [ ! -f "$file_path" ]; then
#  echo "File '$file_path' không tồn tại. Vui lòng kiểm tra lại."
#  exit 1
#fi
#  # Tính số dòng trong file
#line_count=$(wc -l < "$file_path")
#  # Kiểm tra nếu file có ít hơn 2 dòng
#if [ "$line_count" -lt 2 ]; then
#  echo "File '$file_path' phải có ít nhất 2 dòng để chèn nội dung."
#  exit 1
#fi
#  # Chèn nội dung vào trước dòng thứ (độ dài file - 1)
#insert_line=$((line_count - 1))
#  # Sử dụng sed để chèn nội dung vào dòng đã tính
#sed -i "${insert_line}i $content" "$file_path"
#
#echo "Tất cả các file và thư mục cho module $feature_name đã được tạo thành công."
#
## Mở thư mục module trong VSCode (nếu có cài đặt VSCode)
#code lib/features/presentation/pages/${feature_name}_page/${feature_name}_page.dart
