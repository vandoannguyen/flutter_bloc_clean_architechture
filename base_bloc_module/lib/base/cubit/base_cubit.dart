import 'dart:async';

import 'package:base_bloc_module/models/message_model.dart';
import 'package:bloc/bloc.dart';

abstract class BaseCubit<STATE> extends Cubit<STATE> {
  BaseCubit(STATE initialState) : super(initialState);

  final StreamController<bool> dialogLoading = StreamController();
  final StreamController<MessageModel> showMessage = StreamController();
  final StreamController<String> toName = StreamController();
  final StreamController<dynamic> back = StreamController();

  @override
  Future<void> close() {
    _parentCloseStream();
    return super.close();
  }

  void closeStream();

  void _parentCloseStream() {
    closeStream();
    dialogLoading.close();
    showMessage.close();
    toName.close();
    back.close();
  }
}
