import '../../models/message_model.dart';
import 'base_state_cubit.dart';

class BaseCubitEvent extends BaseStateCubit {}

class OnLoadingEvent extends BaseCubitEvent {
  bool isLoading;

  OnLoadingEvent(this.isLoading);
}

class OnMessageEvent extends BaseCubitEvent {
  final MessageModel message;

  OnMessageEvent(this.message);
}

class OnChangeScreenEvent extends BaseCubitEvent {
  String route;
  dynamic data;

  OnChangeScreenEvent(this.route, {this.data});
}
