import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_state.dart';
import '../widgets/category_banner.dart';
//import '../models/app_constants.dart';

class Categories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CategoriesState();
  }
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    // final double deviceHeight = MediaQuery.of(context).size.height;
    // final double targetHeight = deviceHeight / 4;
    //final appCategories = AppConstants.of(context).categories;

    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Categories"),
              backgroundColor: Color(0xFF6A88BA),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: CategoryBanner(
                    category: appState.categories[0],
                  ),
                ),
                Expanded(
                  child: CategoryBanner(
                    category: appState.categories[1],
                  ),
                ),
                Expanded(
                  child: CategoryBanner(
                    category: appState.categories[2],
                  ),
                ),
                Expanded(
                  child: CategoryBanner(
                    category: appState.categories[3],
                  ),
                ),
              ],
            ));
      },
    );
  }
}
