import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'models/app_state.dart';
//import 'models/app_constants.dart';
import 'package:today/models/app_constants.dart';
//import 'package:flutter/services.dart';
import 'pages/home_widget.dart';
import 'pages/category_page.dart';
import 'models/todo_category.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final routeObserver = AppConstants.of(context).routeObserver;

    return ScopedModel<AppState>(
      model: AppState(),
      child: MaterialApp(
        title: 'Today',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (BuildContext context) => Home(),
        },
        navigatorObservers: <NavigatorObserver>[routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          final List<String> _pathElements = settings.name.split('/');

          if (_pathElements[1] == 'category') {
            final Category _category = settings.arguments;
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) =>
                  CategoryPage(settings.arguments),
            );
          }
        },
      ),
    );
  }
}

// entrypoint
void main() {
  runApp(
    AppConstants(
      child: MyApp(),
    ),
  );
}
