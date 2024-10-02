import 'package:base_flutter_bloc/view/home/home_screen.dart';
import 'package:base_flutter_bloc/view/login/login_screen.dart';
import 'package:flutter/material.dart';

enum AppRoutes {
  login,
  home;

  Widget getPage(BuildContext context) {
    switch (this) {
      case AppRoutes.login:
        return const LoginScreen();
      case AppRoutes.home:
        return const HomeScreen();
    }
  }

  String get routeName => "/$name";
}
