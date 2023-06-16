import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_model.freezed.dart';
@freezed
class ContentModel with _$ContentModel {
  @JsonSerializable(explicitToJson: true)
  factory ContentModel({String? a, String? b}) = _ContentModel;
}
