import 'package:base_flutter_bloc/view/main/main_view.dart';
import 'package:base_flutter_bloc/view/main2/main2_view.dart';
import 'package:flutter/material.dart';

enum AppRoutes {
  INIT,
  MAIN2;

  Widget getPage(BuildContext context) {
    switch (this) {
      case AppRoutes.INIT:
        return MainView();
      case AppRoutes.MAIN2:
        return const MainView2();
    }
  }

  String get routeName => "/$name";
}
