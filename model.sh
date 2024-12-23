#!/bin/bash

# Kiểm tra số lượng tham số
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <model_name>"
  exit 1
fi

MODEL_NAME_RAW=$1
# Lấy tên package từ pubspec.yaml
PACKAGE_NAME=$(grep '^name:' pubspec.yaml | awk '{print $2}')

if [ -z "$PACKAGE_NAME" ]; then
  echo "Error: Unable to detect package name from pubspec.yaml"
  exit 1
fi
# Hàm chuyển đổi sang PascalCase (ClassName)
to_pascal_case() {
  echo "$1" | sed -r 's/(^|_)([a-z])/\U\2/g'
}

# Hàm chuyển đổi sang snake_case (class_name)
to_snake_case() {
  echo "$1" | sed -r 's/([a-z0-9])([A-Z])/\1_\2/g' | tr '[:upper:]' '[:lower:]'
}

CLASS_MODEL_NAME=$(to_pascal_case "${MODEL_NAME_RAW}Model")
CLASS_ENTITY_NAME=$(to_pascal_case "${MODEL_NAME_RAW}Entity")
CLASS_ADAPTER_NAME=$(to_pascal_case "${MODEL_NAME_RAW}Adapter")
FILE_MODEL_NAME=$(to_snake_case "${MODEL_NAME_RAW}_MODEL").dart
FILE_ENTITY_NAME=$(to_snake_case "${MODEL_NAME_RAW}_ENTITY").dart
FILE_ADAPTER_NAME=$(to_snake_case "${MODEL_NAME_RAW}_ADAPTER").dart
FOLDER_NAME=$(to_snake_case "$MODEL_NAME_RAW")
FOLDER_MODEL_NAME=$(to_snake_case "${MODEL_NAME_RAW}_MODEL")
FOLDER_ENTITY_NAME=$(to_snake_case "${MODEL_NAME_RAW}_ENTITY")

# Đường dẫn lưu file
SAVE_PATH="lib/data/models/$FOLDER_NAME/$FILE_MODEL_NAME"
SAVE_ENTITY_PATH="lib/domain/entities/$FOLDER_NAME/$FILE_ENTITY_NAME"
SAVE_ADAPTER_PATH="lib/domain/adapters/$FILE_ADAPTER_NAME"

# Tạo thư mục nếu chưa tồn tại
mkdir -p "$(dirname "$SAVE_PATH")"
mkdir -p "$(dirname "$SAVE_ENTITY_PATH")"
mkdir -p "$(dirname "$SAVE_ADAPTER_PATH")"

# Nội dung của file model
MODEL_CONTENT="import 'package:freezed_annotation/freezed_annotation.dart';
part '$FOLDER_MODEL_NAME.freezed.dart';
@freezed
class $CLASS_MODEL_NAME with _\$$CLASS_MODEL_NAME {
 factory $CLASS_MODEL_NAME({String? a, String? b}) = _$CLASS_MODEL_NAME;
}
"
# Nội dung của file entity
ENTITY_CONTENT="import 'package:freezed_annotation/freezed_annotation.dart';
part '$FOLDER_ENTITY_NAME.freezed.dart';
@freezed
class $CLASS_ENTITY_NAME with _\$$CLASS_ENTITY_NAME {
 factory $CLASS_ENTITY_NAME({String? a, String? b}) = _$CLASS_ENTITY_NAME;
}
"
ADAPTER_CONTENT="import 'package:$PACKAGE_NAME/domain/adapters/base_adapter.dart';
import 'package:$PACKAGE_NAME/domain/entities/$FOLDER_NAME/$FILE_ENTITY_NAME';
import 'package:$PACKAGE_NAME/data/models/$FOLDER_NAME/$FILE_MODEL_NAME';

class $CLASS_ADAPTER_NAME
    extends BaseAdapter<$CLASS_ENTITY_NAME, $CLASS_MODEL_NAME> {
  @override
  entityToModel(data) {
    return $CLASS_MODEL_NAME();
  }

  @override
  modelToEntity(data) {
    return $CLASS_ENTITY_NAME();
  }
}
"

chmod +w $SAVE_PATH

chmod +w $SAVE_ENTITY_PATH

chmod +w $SAVE_ADAPTER_PATH

# Ghi nội dung vào file
echo "$MODEL_CONTENT" > "$SAVE_PATH"

echo "$ENTITY_CONTENT" > "$SAVE_ENTITY_PATH"

echo "$ADAPTER_CONTENT" > "$SAVE_ADAPTER_PATH"

fvm flutter packages pub run build_runner build --delete-conflicting-outputs
