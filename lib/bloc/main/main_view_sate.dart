import 'package:base_bloc_module/base/cubit/base_data_state_cubit.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../model/entity/content/content_model.dart';

part 'main_view_sate.freezed.dart';

@freezed
class MainState extends BaseDataStateCubit with _$MainState {
  factory MainState(
      {@Default(0) int? count,
      @Default("value") String value,
      ContentModel? user}) = _MainState;
}
