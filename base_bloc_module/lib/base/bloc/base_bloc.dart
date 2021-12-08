import 'dart:async';

import 'package:base_bloc_module/models/message_model.dart';
import 'package:bloc/bloc.dart';

abstract class BaseBloc<EVENT, STATE> extends Bloc<EVENT, STATE> {
  Emitter? _emitter;

  BaseBloc(STATE initialState) : super(initialState) {
    on((event, emitter) {
      _emitter = emitter;
      initEvent(event);
    });
  }

  final StreamController<bool> dialogLoading = StreamController();
  final StreamController<MessageModel> showMessage = StreamController();
  final StreamController<String> toName = StreamController();
  final StreamController<dynamic> back = StreamController();

  void initEvent(Object? event);

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

  void emitter(STATE state) {
    if (_emitter != null) {
      _emitter!(state);
    } else {
      throw ("emitter is null");
    }
  }
}
