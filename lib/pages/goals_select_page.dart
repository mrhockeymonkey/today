import 'package:flutter/material.dart';
import 'package:today/models/todo_item.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_constants.dart';
import '../models/app_state.dart';
import '../models/category.dart';

class ItemSelectPage extends StatefulWidget {
  final List<ToDoItem> items;
  final int goalIndex;

  ItemSelectPage({
    @required this.items,
    @required this.goalIndex,
  });

  @override
  State<StatefulWidget> createState() {
    return _ItemSelectPage();
  }
}

class _ItemSelectPage extends State<ItemSelectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Goal"),
        backgroundColor: AppConstants.appBarColor,
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        ToDoItem item = widget.items[index];
        AppState appState = ScopedModel.of<AppState>(context);
        int categoryIndex = appState.categoryIndexOf(item);
        Category category = appState.categories[categoryIndex];

        return ListTile(
          title: Text(item.title),
          leading: Icon(
            AppConstants.categoryIcons[categoryIndex],
            color: category.color,
          ),
          subtitle: Text(
            "${category.name.toUpperCase()}",
            style: TextStyle(
              color: category.color,
            ),
          ),
          onTap: () => setState(() {
            AppState appState = ScopedModel.of<AppState>(context);
            appState.setGoalItem(widget.goalIndex, item);
            Navigator.of(context).pop();
          }),
        );
      },
    );
  }
}
