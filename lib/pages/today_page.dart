import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';
import 'package:today/widgets/new_item_fab.dart';
import 'package:today/widgets/drawer_menu.dart';

class TodayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage> {
  Color todayColor = AppConstants.todayColor;

  @override
  Widget build(BuildContext context) {
    print("BUILD - today_page");
    //AppConstants.changeStatusColor(todayColor);

    return Scaffold(
      appBar: AppBar(
        title: Text("Today"),
        backgroundColor: todayColor,
        elevation: 0.0,
      ),
      drawer: DrawerMenu(),
      body: _buildBody(),
      floatingActionButton: NewItemFab(),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FutureBuilder(
          future: appState.storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<ToDoItem> items;
            //var formatter = new DateFormat.MMMMEEEEd();
            // Widget headerText = Text(
            //   DateFormat.MMMMEEEEd().format(DateTime.now()),
            //   style: TextStyle(color: Colors.white),
            // );

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[
                  CategoryHeader(
                    headerColor: todayColor,
                    headerCount: 0,
                  ),
                  CircularProgressIndicator()
                ],
              );
            }

            appState.initialize();
            items = appState.allTodayItems;

            return Column(
              children: <Widget>[
                CategoryHeader(
                  headerColor: todayColor,
                  headerCount: items.length,
                ),
                ToDoList(
                  items: items,
                  pageType: PageType.today,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
