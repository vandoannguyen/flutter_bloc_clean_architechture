import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/entity/content/content_model.dart';

part 'main_view_sate.freezed.dart';

@freezed
class MainState with _$MainState {
  factory MainState(
      {@Default(0) int? count,
      @Default("value") String value,
      ContentModel? user}) = _MainState;
}
