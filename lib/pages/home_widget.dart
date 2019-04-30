import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/pages/today_page.dart';
import 'package:today/pages/later_page.dart';


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

  // didPopNext called when the route above this is popped (with RouteAware)
  @override
  void didPopNext() {
    //FlutterStatusbarcolor.setStatusBarColor(Color(0xFF6A88BA));
    AppConstants.changeStatusColor(Color(0xFF6A88BA));
  }

  @override
  Widget build(BuildContext context) {
    final Category today = AppConstants.of(context).today;
    final _pages = [LaterPage(), TodayPage(), Categories(),];

    return Scaffold(
      body: _pages.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
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

        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
