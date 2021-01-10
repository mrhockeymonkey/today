import 'package:flutter/material.dart';

import '../models/app_constants.dart';
import '../pages/later_page.dart';
import '../pages/today_page.dart';
import '../pages/completed_page.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    print("BUILD - home_widget");
    AppConstants.changeStatusColor(Colors.transparent);

    // a list of pages to display per nav bar item
    final _pages = [
      //ToDoPage(),
      LaterPage(),
      TodayPage(),
      CompletedPage(),
    ];

    // a list of nav bar items
    final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        label: 'Scheduled',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.format_list_numbered),
        label: 'To Do',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.done),
        label: 'Done',
      ),
    ];

    return WillPopScope(
      onWillPop: () async => false, // dont allow user to pop on home screen
      child: Scaffold(
        body: _pages.elementAt(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          items: _bottomNavigationBarItems,
          fixedColor: AppConstants.todayHeaderColor,
          selectedFontSize: 18.0,
        ),
      ),
    );
  }

  // updates displayed page based on selected nav bar item
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
