import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:flutter/material.dart';

import '../module/view/main/main_view.dart';
import '../module/view/main2/main2_view.dart';

class CommonPage {
  static List pages = [
    RouteModel(
      CommonRoutes.INIT,
      const MainView(),
    ),
    RouteModel(
      CommonRoutes.MAIN2,
      const MainView2(),
    ),
  ];
}

class RouteModel {
  String name;
  Widget page;

  RouteModel(this.name, this.page);
}
