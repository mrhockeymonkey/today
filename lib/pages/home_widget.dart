import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/pages/later_page.dart';
import 'package:today/pages/todo_page.dart';
import 'package:today/pages/today_page.dart';
import 'package:today/pages/completed_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //FlutterStatusbarcolor.setStatusBarColor(Color(0xFF6A88BA));
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    print("BUILD - home_widget");
    AppConstants.changeStatusColor(Colors.transparent);
    // a navigator key to for use with CategoryNavigator
    //final navigatorKey = GlobalKey<NavigatorState>();

    // a list of pages to display per nav bar item
    final _pages = [
      LaterPage(),
      ToDoPage(),
      TodayPage(),
      CompletedPage(),
    ];

    // a list of nav bar items
    final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        title: Text('Later'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text('To Do'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.event_available),
        title: Text('Today'),
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
          fixedColor: AppConstants.highlightColor,
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
