import 'dart:async';

import 'package:base_bloc_module/base/cubit/base_cubit_event.dart';
import 'package:base_bloc_module/base/cubit/base_data_state_cubit.dart';
import 'package:base_bloc_module/models/message_model.dart';
import 'package:bloc/bloc.dart';

import 'base_state_cubit.dart';

abstract class BaseCubit<STATE extends BaseStateCubit>
    extends Cubit<BaseStateCubit> {
  late STATE dataState;

  BaseCubit(STATE initialState) : super(initialState) {
    this.dataState = initialState;
  }

  void showLoading() {
    emit(OnLoadingEvent(true));
  }

  void hideLoading() {
    emit(OnLoadingEvent(false));
  }

  void changeScreen(String routeName, dynamic data) {
    emit(OnChangeScreenEvent(routeName, data: data));
  }

  void showMessage(String message, {MessageType type = MessageType.success}) {
    emit(
      OnMessageEvent(
        MessageModel(mess: message, messageType: type),
      ),
    );
  }

  @override
  void onChange(Change<BaseStateCubit> change) {
    if (change.nextState is STATE) {
      dataState = change.nextState as STATE;
    }
    super.onChange(change);
  }
}
