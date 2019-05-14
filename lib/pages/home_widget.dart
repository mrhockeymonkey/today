import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/pages/later_page.dart';
import 'package:today/pages/today_page.dart';
import 'package:today/pages/completed_page.dart';
import 'package:today/widgets/category_navigator.dart';

import './categories_page.dart';
import '../pages/category_page.dart';

import '../models/todo_category.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //FlutterStatusbarcolor.setStatusBarColor(Color(0xFF6A88BA));
    return _HomeState();
  }
}

class _HomeState extends State<Home> with RouteAware {
  int _currentIndex = 1;

  @override
  void didChangeDependencies() {
    final routeObserver = AppConstants.of(context).routeObserver;
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    final routeObserver = AppConstants.of(context).routeObserver;
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // didPopNext called when the route above this is popped (uses RouteAware)
  @override
  void didPopNext() {
    AppConstants.changeStatusColor(Color(0xFF6A88BA));
  }

  @override
  Widget build(BuildContext context) {
    // a navigator key to for use with CategoryNavigator
    final navigatorKey = GlobalKey<NavigatorState>();
    
    // a list of pages to display per nav bar item
    final _pages = [
      LaterPage(),
      TodayPage(),
      CategoryNavigator(
        navigatorKey: navigatorKey,
      ),
      CompletedPage(),
    ];

    // a list of nav bar items
    final List<BottomNavigationBarItem> _bottomNavigationBarItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.today),
        title: Text('Later'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.done),
        title: Text('Today'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.list),
        title: Text('To Do'),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.done_all),
        title: Text('Done'),
      ),
    ];

    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: _bottomNavigationBarItems,
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
