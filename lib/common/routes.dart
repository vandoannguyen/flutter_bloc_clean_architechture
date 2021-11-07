import 'package:baese_flutter_bloc/module/presenstation/page/main/main_view.dart';
import 'package:flutter/material.dart';

class CommonRoutes {
  static const INIT = "/";
  static List pages = [
    RouteModel(INIT, MainView()),
  ];
}

class RouteModel {
  String name;
  Widget page;

  RouteModel(this.name, this.page);
}
