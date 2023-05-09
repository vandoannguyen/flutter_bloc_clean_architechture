import 'package:baese_flutter_bloc/module/presenstation/page/main/main_view.dart';
import 'package:baese_flutter_bloc/module/presenstation/page/main2/main2_view.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:flutter/material.dart';

class CommonPage {
  static List pages = [
    RouteModel(
      CommonRoutes.INIT,
      MainView(),
    ),
    RouteModel(
      CommonRoutes.MAIN2,
      Main2View(),
    ),
  ];
}

class RouteModel {
  String name;
  Widget page;

  RouteModel(this.name, this.page);
}
