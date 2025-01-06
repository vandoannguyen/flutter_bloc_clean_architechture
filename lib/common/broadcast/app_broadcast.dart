import 'dart:async';
import 'package:base_flutter_bloc/common/broadcast/app_broad_cast_data.dart';

class AppBroadCast {
  static final AppBroadCast _instance = AppBroadCast._internal();
  final StreamController<AppBroadCastData> _streamController =
      StreamController.broadcast();

  AppBroadCast._internal();

  factory AppBroadCast() {
    return _instance;
  }

  void push(AppBroadCastData data) {
    _streamController.sink.add(data);
  }

  StreamSubscription<AppBroadCastData> listen(
      Function(AppBroadCastData event) onData) {
    return _streamController.stream.listen(onData);
  }
}
