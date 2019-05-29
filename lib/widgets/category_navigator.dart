import 'package:flutter/material.dart';

import 'package:today/pages/categories_page.dart';
import 'package:today/pages/category_page.dart';

// returns a new navigator to manage a seperate stack of category pages
// pages pushed onto this stack will render from within the HomePage 
// this means the bottom nav bar will still be available
class CategoryNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  CategoryNavigator({this.navigatorKey});

  // function to push a specified category page onto the stack
  void _pushCategoryPage(BuildContext context, int categoryIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CategoryPage(categoryIndex)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) => CategoriesPage(_pushCategoryPage));
      },
    );
  }
}
