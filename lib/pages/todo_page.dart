import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/models/category.dart';
// import 'package:today/models/todo_item.dart';
import 'package:today/pages/item_page.dart';
import './settings_page.dart';
import 'package:today/widgets/new_item_fab.dart';

class ToDoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoPageState();
  }
}

class _ToDoPageState extends State<ToDoPage> {
  Color headerColor = AppConstants.todoHeaderColor;

  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(AppConstants.laterColor);

    print("Build: todo page");
    return Scaffold(
      appBar: AppBar(
        title: Text("Backlog"),
        backgroundColor: headerColor,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: _buildBody(),
      floatingActionButton: NewItemFab(
        color: headerColor,
        initIsToday: false,
      ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FutureBuilder(
          future: appState.storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<ToDoItem> items;

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[
                  CategoryHeader(
                    headerColor: headerColor,
                    headerCount: 0,
                  ),
                  CircularProgressIndicator()
                ],
              );
            }

            appState.initialize();
            items = appState.allToDoItems;

            return CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CategoryHeader(
                      headerColor: headerColor,
                      headerCount: items.length,
                    ),
                  ],
                ),
              ),
              ToDoList(
                items: items,
                pageType: PageType.todo,
              ),
            ]);
            // return Column(
            //   children: <Widget>[
            //     CategoryHeader(
            //       headerColor: headerColor,
            //       headerCount: items.length,
            //     ),
            //     ToDoList(
            //       items: items,
            //       pageType: PageType.todo,
            //     ),
            //   ],
            // );
          },
        );
      },
    );
  }
}
