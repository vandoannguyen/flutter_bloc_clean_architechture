import 'dart:async';

import 'package:baese_flutter_bloc/common/message_model.dart';
import 'package:bloc/bloc.dart';

abstract class BaseBloc<EVENT, STATE> extends Bloc<EVENT, STATE> {
  BaseBloc(STATE initialState) : super(initialState) {
    initEventState();
  }

  final StreamController<bool> dialogLoading = StreamController();
  final StreamController<MessageModel> showMessage = StreamController();

  void initEventState();

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
  }
}
