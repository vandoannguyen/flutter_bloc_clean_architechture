import 'package:base_bloc_module/models/message_model.dart';
import 'package:flutter/material.dart';

class BaseBlocConfig {
  BaseBlocConfig._privateConstructor();

  static final BaseBlocConfig _instance = BaseBlocConfig._privateConstructor();

  static BaseBlocConfig get instance => _instance;

  Widget Function(MessageModel)? _messageWidget;
  Widget Function()? _loadingWidget;

  Widget Function(MessageModel)? get messageWidget => _messageWidget;

  Widget Function()? get loadingWidget => _loadingWidget;

  void configMessageWidget(Widget Function(MessageModel) messageWidget) {
    _messageWidget = messageWidget;
  }

  void configLoadingWidget(Widget Function() loadingWidget) {
    _loadingWidget = loadingWidget;
  }
}
