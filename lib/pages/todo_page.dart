import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_constants.dart';
import '../widgets/date_header.dart';
import '../widgets/todo_list.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import '../models/category.dart';
// import '../models/todo_item.dart';
import '../pages/item_page.dart';
import './settings_page.dart';
import '../widgets/new_item_fab.dart';

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
        title: Image.asset(
          'dev_assets/app_title.png',
          fit: BoxFit.cover,
          height: 40,
        ),
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
            int completedCount;

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[
                  DateHeader(),
                  CircularProgressIndicator()
                ],
              );
            }

            appState.initialize();
            items = appState.allToDoItems;
            completedCount = appState.allCompletedTodayItems.length;

            return CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    DateHeader()
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
