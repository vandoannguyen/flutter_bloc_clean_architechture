import 'package:base_flutter_bloc/features/auth/presentation/pages/login_screen.dart';
import 'package:base_flutter_bloc/features/home/presentation/pages/home_screen.dart';
import 'package:base_flutter_bloc/features/register_account/presentation/pages/register_account_screen.dart';
import 'package:flutter/material.dart';

enum AppRoutes {
  splash,
  login,
  home,
  registerAccount;

  Widget getPage(BuildContext context) {
    switch (this) {
      case AppRoutes.splash:
        return const LoginScreen();
      case AppRoutes.login:
        return const LoginScreen();
      case AppRoutes.home:
        return const HomeScreen();
      case AppRoutes.registerAccount:
        return const RegisterAccountScreen();
    }
  }

  String get routeName => "/$name";
}
