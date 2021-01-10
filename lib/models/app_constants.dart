import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

// inherited widget used in main to propogate and share anywhere in the app
class AppConstants extends InheritedWidget {
  // colors
  static final Color appBarColor = Color(0xFF07618E);

  // action colors
  static final Color todoColor = Color(0xFFFBAF28);
  static final Color completeColor = Color(0xFF64DD17);
  static final Color completedColor = Colors.grey;
  static final Color laterColor = Colors.grey;

  // page header colors
  static final Color laterHeaderColor = Color(0xFF07618E);
  static final Color todoHeaderColor = Color(0xFF07618E);
  static final Color todayHeaderColor = Color(0xFF07618E);
  static final Color completedHeaderColor = Color(0xFF07618E);
  static final Color highlightColor = Color(0xFF37C7CB);

  static final double cirleAvatarRadius = 28.0;
  static final double headerHeight = 72.0;

  // category colors
  static final List<Color> categoryColors = [
    const Color(0xFFEE534F), //must do
    const Color(0xFF00B8D4), //want to
    const Color(0xFFFBAF28), // should do
    const Color(0xFF01BFA5), // could do
    const Color(0xFF9E9E9E) // fyi
  ];

  static final Map<String, IconData> icons = {
    "flag": Entypo.flag,
    "game_controller": Entypo.game_controller,
    "pin": Entypo.pin,
    "code": Entypo.code,
    "book": Entypo.book,
    "credit": Entypo.credit,
    "credit_card": Entypo.credit_card,
    "graduation_cap": Entypo.graduation_cap,
    "help": Entypo.help,
    "home": Entypo.home,
    "info": Entypo.info,
    "language": Entypo.language,
    "leaf": Entypo.leaf,
    "shopping_cart": Entypo.shopping_cart,
    "star": Entypo.star,
    "tools": Entypo.tools,
  };

  final RouteObserver<Route> routeObserver = new RouteObserver<Route>();

  AppConstants({Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppConstants of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConstants>();

  static changeStatusColor(Color color) async {
    print("changing status bar color to " + color.toString());
    try {
      await FlutterStatusbarcolor.setStatusBarColor(color);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static changeNavBarColor(Color color) async {
    print("changing nav bar color to " + color.toString());
    try {
      await FlutterStatusbarcolor.setNavigationBarColor(color);
      await FlutterStatusbarcolor.setNavigationBarWhiteForeground(true);
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

  static String headerTextDate = DateFormat.MMMMEEEEd().format(DateTime.now());
}
