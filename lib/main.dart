import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './models/app_state.dart';
import './models/app_constants.dart';
import './pages/home_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeObserver = AppConstants.of(context).routeObserver;

    return ScopedModel<AppState>(
      model: AppState(),
      child: MaterialApp(
        title: '5 Things',
        theme: ThemeData(primarySwatch: Colors.blue),
        routes: {
          '/': (BuildContext context) => Home(),
        },
        navigatorObservers: <NavigatorObserver>[routeObserver],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'GB'),
        ],
        // onGenerateRoute: (RouteSettings settings) {
        //   final List<String> _pathElements = settings.name.split('/');

        //   // if pushing to /category page then pass through the index required also
        //   if (_pathElements[1] == 'category') {
        //     final int _index = settings.arguments;
        //     return MaterialPageRoute<bool>(
        //       builder: (BuildContext context) =>
        //           CategoryPage(_index),
        //     );
        //   }
        // },
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
