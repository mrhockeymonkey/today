import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';
import 'package:today/widgets/new_item_fab.dart';
import './settings_page.dart';

class TodayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage> {
  Color headerColor = AppConstants.todayHeaderColor;

  @override
  Widget build(BuildContext context) {
    print("BUILD - today_page");
    //AppConstants.changeStatusColor(todayColor);

    return Scaffold(
      appBar: AppBar(
        title: Text("Today"),
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
        initIsToday: true,
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
            int backlogCount;
            //var formatter = new DateFormat.MMMMEEEEd();
            // Widget headerText = Text(
            //   DateFormat.MMMMEEEEd().format(DateTime.now()),
            //   style: TextStyle(color: Colors.white),
            // );

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
            items = appState.allTodayItems;
            backlogCount = appState.allToDoItems.length;

            return CustomScrollView(
              slivers: <Widget>[
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
                  pageType: PageType.today,
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: false,
                  child: Container(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate([
                    Ink(
                      color: Colors.grey,
                      height: AppConstants.headerHeight,
                      child: ListTile(
                        title: Text("${backlogCount.toString()} more items in backlog..."),
                      ),
                    ),
                  ]),
                )
              ],
            );

            // return Column(
            //   children: <Widget>[
            //     CategoryHeader(
            //       headerColor: headerColor,
            //       headerCount: items.length,
            //     ),
            //     ToDoList(
            //       items: items,
            //       pageType: PageType.today,
            //     ),
            //     Ink(
            //       color: Colors.grey,
            //       child: ListTile(
            //         title: Text("Plus x more items in backlog..."),
            //       ),
            //     )
            //   ],
            // );
          },
        );
      },
    );
  }
}
