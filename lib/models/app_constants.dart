import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart';

import './category.dart';

// inherited widget used in main to propogate and share anywhere in the app
class AppConstants extends InheritedWidget {
  static final Color todoColor = Color(0xFFFBAF28);
  static final Color completeColor = Color(0xFF64DD17);
  static final Color completedColor = Colors.grey;
  static final Color todayColor = Color(0xFF6A88BA);
  static final Color laterColor = Color(0xFF6A88BA);
  static final double cirleAvatarRadius = 28.0;
  static final double headerHeight = 90.0;

  final Category today = Category(name: 'TODAY', color: todayColor);

  final RouteObserver<Route> routeObserver = new RouteObserver<Route>();

  AppConstants({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppConstants of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(AppConstants);

  static changeStatusColor(Color color) async {
    print("changing color to " + color.toString());
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static Widget headerTextDate = Text(
    DateFormat.MMMMEEEEd().format(DateTime.now()),
    style: TextStyle(color: Colors.white),
  );
}
