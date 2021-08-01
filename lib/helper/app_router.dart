import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();
  static AppRouter route = AppRouter._();
  GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

  pushNamed(String routeName, Map<String, dynamic>? arguments) {
    navKey.currentState!.pushNamed(routeName, arguments: arguments!);
  }

  replacmentRoute(String routeName) {
    navKey.currentState!.pushReplacementNamed(routeName);
  }

  replacmentRouteWithArgs(String routeName, Object args) {
    navKey.currentState!.pushReplacementNamed(routeName, arguments: args);
  }
}
