import 'package:baese_flutter_bloc/module/domain/entity/content_model.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'main_view_sate.freezed.dart';

@freezed
class MainState extends MainEventState with _$MainState {
  // int? count = 0;
  // String value = "value";
  // ContentModel? user;

  factory MainState(
      {@Default(0) int? count,
      @Default("value") String value,
      ContentModel? user}) = _MainState;
}
class MainEventState{

}
class ShowDialogState extends MainEventState{

}
class NavigateMainState extends MainEventState{

}