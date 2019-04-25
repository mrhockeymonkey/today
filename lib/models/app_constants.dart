import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

import './todo_category.dart';

// inherited widget used in main to propogate and share anywhere in the app
class AppConstants extends InheritedWidget {

  final Category today = Category(name: 'TODAY', color: const Color(0xFF6A88BA));

  final RouteObserver<Route> routeObserver = new RouteObserver<Route>();

  AppConstants({Widget child}): super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  
  static AppConstants of(BuildContext context) => context.inheritFromWidgetOfExactType(AppConstants);

  static changeStatusColor(Color color) async {
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }
}