import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:today/widgets/goals_header.dart';

import '../models/app_constants.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import 'goals_select_page.dart';
import '../models/category.dart';
import '../widgets/tdl_tile.dart';
import '../widgets/note_header.dart';
import '../widgets/tdl_base.dart';
import '../widgets/highlighted_today.dart';
import '../widgets/tdl_primary.dart';
import '../widgets/new_item_fab.dart';
import 'settings_page.dart';

class GoalsPage extends StatefulWidget {
  final Map<int, ToDoItem> goals;

  GoalsPage({
    @required this.goals,
  });

  @override
  State<StatefulWidget> createState() {
    return _GoalsPageState();
  }
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD - goals_page");

    return Scaffold(
      appBar: AppBar(
        title: Text("GOALS"),
        backgroundColor: AppConstants.appBarColor,
        elevation: 0.0,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      child: Icon(Icons.done),
      backgroundColor: AppConstants.appBarColor,
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _buildBody() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) =>
          _buildTile(context, index),
    );
  }

  Widget _buildTile(BuildContext context, int index) {
    if (widget.goals.containsKey(index)) {
      ToDoItem item = widget.goals[index];
      AppState appState = ScopedModel.of<AppState>(context);
      int categoryIndex = appState.categoryIndexOf(item);
      Category category = appState.categories[categoryIndex];

      return TdlTile(
        item: item,
        category: category,
        categoryIndex: categoryIndex,
        onTap: () => _pushItemSelectPage(context, index),
        trailing: IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              appState.removeGoalItem(index);
            });
          },
        ),
      );
    }
    return ListTile(
      leading: Icon(Entypo.pin),
      title: Text("Select an item"),
      onTap: () => _pushItemSelectPage(context, index),
    );
  }

  _pushItemSelectPage(BuildContext context, int goalIndex) {
    List<ToDoItem> allItems =
        ScopedModel.of<AppState>(context).allToDoAndDueItems;
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          return ItemSelectPage(
            items: allItems,
            goalIndex: goalIndex,
          );
        },
      ),
    ).then((_) => {
          setState(() {
            print("foo");
          })
        });
  }
}
