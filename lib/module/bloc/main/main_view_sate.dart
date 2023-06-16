import 'package:baese_flutter_bloc/module/domain/entity/content/content_model.dart';
import 'package:base_bloc_module/base/cubit/base_state_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'main_view_sate.freezed.dart';

@freezed
class MainState with _$MainState {
  // int? count = 0;
  // String value = "value";
  // ContentModel? user;

  factory MainState(
      {@Default(0) int? count,
      @Default("value") String value,
      ContentModel? user}) = _MainState;
// MainState({this.count = 0, this.value = "value", this.user});
//
//   @override
//   List<Object?> equal() {
//     return [count, value, user];
//   }

// MainState copyWith({count = 0, value, user}) {
//   return MainState(
//       count: count ?? this.count,
//       value: value ?? this.value,
//       user: user ?? this.user);
// }
}
