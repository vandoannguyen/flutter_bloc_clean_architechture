import 'package:flutter/cupertino.dart';

class NavigatorUtils {
  static final NavigatorUtils instance = NavigatorUtils._getInstance();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  NavigatorUtils._getInstance();

  Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    if (checkKey()) {
      return Navigator.of(_navigatorKey.currentContext!)
          .pushNamed(routeName, arguments: arguments);
    } else {
      return null;
    }
  }

  Future<T?>? pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    RoutePredicate predicate, {
    Object? arguments,
  }) {
    if (checkKey()) {
      return Navigator.of(_navigatorKey.currentContext!)
          .pushNamedAndRemoveUntil(newRouteName, predicate,
              arguments: arguments);
    } else {
      return null;
    }
  }

  Future<T?>? pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    if (checkKey()) {
      return Navigator.of(_navigatorKey.currentContext!).pushReplacementNamed(
          routeName,
          result: result,
          arguments: arguments);
    } else {
      return null;
    }
  }

  Future<T?>? push<T extends Object?>(Route<T> route) {
    if (checkKey()) {
      return Navigator.of(_navigatorKey.currentContext!).push(route);
    } else {
      return null;
    }
  }

  Future<T?>? pushReplacement<T extends Object?, TO extends Object?>(
      Route<T> newRoute,
      {TO? result}) {
    if (checkKey()) {
      return Navigator.of(_navigatorKey.currentContext!)
          .pushReplacement(newRoute, result: result);
    } else {
      return null;
    }
  }

  bool checkKey() {
    if (_navigatorKey.currentContext != null) {
      return true;
    } else {
      throw ("Chưa gắn key cho nó");
    }
  }

  Future<T?>? pushAndRemoveUntil<T extends Object?>(
      Route<T> newRoute, RoutePredicate predicate) {
    if (checkKey()) {
      return Navigator.of(_navigatorKey.currentContext!)
          .pushAndRemoveUntil(newRoute, predicate);
    } else {
      return null;
    }
  }

  static void showNoInternetErrorDialog() {}

  static void showGeneralErrorDialog() {}
}
