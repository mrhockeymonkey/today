import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart';

import './category.dart';

// inherited widget used in main to propogate and share anywhere in the app
class AppConstants extends InheritedWidget {
  // action colors
  static final Color todoColor = Color(0xFFFBAF28);
  static final Color completeColor = Color(0xFF64DD17);
  static final Color completedColor = Colors.grey;
  static final Color laterColor = Colors.grey;

  
  // page header colors
  static final Color laterHeaderColor = Color(0xFF23395B);
  static final Color todoHeaderColor = Color(0xFF214D7A);
  static final Color todayHeaderColor = Color(0xFFF07618E);
  static final Color completedHeaderColor = Color(0xFF247BA0);
  static final Color highlightColor = Color(0xFF37C7CB);

  static final double cirleAvatarRadius = 28.0;
  static final double headerHeight = 72.0; //90.0;

  //final Category today = Category(name: 'TODAY', color: todayHeaderColor);
  //static final int maxTodayItems = 5;

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
