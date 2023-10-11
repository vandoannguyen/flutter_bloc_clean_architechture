import 'package:baese_flutter_bloc/routes/routes.dart';
import 'package:flutter/material.dart';

import '../view/main/main_view.dart';
import '../view/main2/main2_view.dart';

class AppPage {
  static List pages = [
    RouteModel(
      AppRoutes.INIT,
      MainView(),
    ),
    RouteModel(
      AppRoutes.MAIN2,
      const MainView2(),
    ),
  ];
}

class RouteModel {
  String name;
  Widget page;

  RouteModel(this.name, this.page);
}
