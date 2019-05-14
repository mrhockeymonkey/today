import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/todo_category.dart';
import 'package:today/pages/item_page.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';
import 'package:today/models/app_state.dart';

class CategoryPage extends StatefulWidget {
  //final Category category;
  final int categoryIndex;

  CategoryPage(this.categoryIndex);

  @override
  State<StatefulWidget> createState() {
    return _CategoryState();
  }
}

class _CategoryState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    Category category =
        ScopedModel.of<AppState>(context).categories[widget.categoryIndex];
    AppConstants.changeStatusColor(category.color);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: category.color,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          CategoryHeader(
            headerColor: category.color,
            headerCount: category.leftToDoCount,
          ),
          category.items.length == 0
              ? Text("Nothing To Do")
              : ToDoList(
                  items: category.itemsSorted,
                  pageType: PageType.category,
                ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    Category category =
        ScopedModel.of<AppState>(context).categories[widget.categoryIndex];

    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: category.color,
      onPressed: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
              builder: (context) => ItemPage(
                    categoryIndex: widget.categoryIndex,
                  )),
        );
      },
    );
  }
}
