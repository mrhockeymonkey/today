import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
//import '../models/app_constants.dart';
import '../models/todo_category.dart';

class CategoryBanner extends StatelessWidget {
  final Category category;
  //final int index;
  // final String name;
  // final Color color;

  CategoryBanner({this.category});

  @override
  Widget build(BuildContext context) {
    //final Category category = AppConstants.of(context).categories[index];

    return Container(
      padding: EdgeInsets.all(10.0),
      color: category.color,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(category.name),
          ),
          CircleAvatar(
            child: Text("10"),
            radius: AppConstants.cirleAvatarRadius,
            backgroundColor: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.info),
            color: Theme.of(context).accentColor,

            onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/category',
                  arguments: category,
                ),
          ),
        ],
      ),
    );
  }
}
