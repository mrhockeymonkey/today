import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_state.dart';
import 'package:today/models/todo_category.dart';
import '../models/app_constants.dart';

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
    print("build categories page");

    return Scaffold(
        appBar: AppBar(
          title: Text("To Do"),
          backgroundColor: Color(0xFF6A88BA),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        //appState.initialize();
        List<Category> categories = appState.categories;
        List<Widget> categoryBanners = [];

        categoryBanners.add(Expanded(
            child: _buildCategoryBanner(0),
          ));
        categoryBanners.add(Expanded(
            child: _buildCategoryBanner(1),
          ));
        categoryBanners.add(Expanded(
            child: _buildCategoryBanner(2),
          ));
        categoryBanners.add(Expanded(
            child: _buildCategoryBanner(3),
          ));
        // categories.forEach((i) {
        //   categoryBanners.add(Expanded(
        //     child: _buildCategoryBanner(i),
        //   ));
        // });

        return Column(
          children: categoryBanners,
        );
      },
    );
  }

  Widget _buildCategoryBanner(int index) {
    //final Category category = AppConstants.of(context).categories[index];
    Category category =
        ScopedModel.of<AppState>(context).categories[index];

    return Container(
      padding: EdgeInsets.all(10.0),
      color: category.color,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(category.name),
          ),
          CircleAvatar(
            child: Text(category.leftToDoCount.toString()),
            radius: AppConstants.cirleAvatarRadius,
            backgroundColor: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,
            onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/category',
                  arguments: index,
                ),
          ),
        ],
      ),
    );
  }
}
