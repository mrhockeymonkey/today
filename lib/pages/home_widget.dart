import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_constants.dart';
import '../pages/later_page.dart';
//import '../pages/todo_page.dart';
import '../pages/today_page.dart';
import '../pages/completed_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //FlutterStatusbarcolor.setStatusBarColor(Color(0xFF6A88BA));
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    print("BUILD - home_widget");
    AppConstants.changeStatusColor(Colors.transparent);
    //AppConstants.changeNavBarColor(AppConstants.todayHeaderColor);
    // a navigator key to for use with CategoryNavigator
    //final navigatorKey = GlobalKey<NavigatorState>();

    //var mySystemTheme = SystemUiOverlayStyle.light.copyWith(systemNavigationBarColor: AppConstants.todayHeaderColor);
    //SystemChrome.setSystemUIOverlayStyle(mySystemTheme);

    // a list of pages to display per nav bar item
    final _pages = [
      //ToDoPage(),
      LaterPage(),
      TodayPage(),
      CompletedPage(),
    ];

    // a list of nav bar items
    final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
      // BottomNavigationBarItem(
      //   icon: Icon(Icons.list),
      //   title: Text('Backlog'),
      // ),
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        title: Text('Scheduled'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_available),
        title: Text('To Do'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.done_all),
        title: Text('Done'),
      ),
    ];

    return WillPopScope(
      onWillPop: () {
        print("back pressed");
      },
      child: Scaffold(
        body: _pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: _bottomNavigationBarItems,
          fixedColor: AppConstants.todayHeaderColor, //AppConstants.highlightColor,
          selectedFontSize: 18.0,
          //backgroundColor: AppConstants.todayHeaderColor,
        ),
      ),
    );
    // return Scaffold(
    //   body: _pages.elementAt(_currentIndex),
    //   bottomNavigationBar: BottomNavigationBar(
    //     onTap: onTabTapped,
    //     currentIndex: _currentIndex,
    //     type: BottomNavigationBarType.fixed,
    //     items: _bottomNavigationBarItems,
    //   ),
    // );
  }

  // updates displayed page based on selected nav bar item
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
