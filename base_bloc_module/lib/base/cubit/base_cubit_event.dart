import 'package:base_bloc_module/base/bloc/base_state.dart';

import 'base_state_cubit.dart';

class BaseCubitEvent extends BaseStateCubit {}

class OnLoadingEvent extends BaseStateCubit {
  bool isLoading;

  OnLoadingEvent(this.isLoading);
}

class OnMessageEvent extends BaseCubitEvent {
  String message;
  bool isError;

  OnMessageEvent(this.message, {this.isError = false});
}

class OnChangeScreenEvent extends BaseCubitEvent {
  String route;
  dynamic data;

  OnChangeScreenEvent(this.route, {this.data});
}
