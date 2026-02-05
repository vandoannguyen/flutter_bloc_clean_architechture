import 'package:alice/alice.dart';
import 'package:alice/model/alice_configuration.dart';
import 'package:alice_dio/alice_dio_adapter.dart';
import 'package:flutter/material.dart';

class AliceUtils {
  static final AliceUtils instance = AliceUtils._getInstance();
  Alice? _alice;
  AliceDioAdapter? aliceDioAdapter;

  AliceUtils._getInstance() {
    aliceDioAdapter = AliceDioAdapter();
    _alice = Alice(
      configuration: AliceConfiguration(
        showInspectorOnShake: true,
        showShareButton: true,
      ),
    );
    _alice?.addAdapter(aliceDioAdapter!);
  }

  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _alice?.setNavigatorKey(navigatorKey);
  }
}
