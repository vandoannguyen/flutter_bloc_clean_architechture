import 'package:baese_flutter_bloc/module/presenstation/page/main/main_view.dart';
import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:flutter/material.dart';

class CommonPage {
  static List pages = [
    RouteModel(
      CommonRoutes.INIT,
      const MainView(),
    ),
  ];
}

class RouteModel {
  String name;
  Widget page;

  RouteModel(this.name, this.page);
}
