import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../models/app_constants.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import '../widgets/date_header.dart';
import '../widgets/note_header.dart';
import '../widgets/todo_list.dart';
import '../widgets/new_item_fab.dart';
import '../widgets/drawer_menu.dart';
import './settings_page.dart';

class TodayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage> {
  @override
  Widget build(BuildContext context) {
    print("BUILD - today_page");
    //AppConstants.changeStatusColor(todayColor);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'dev_assets/app_title.png',
          fit: BoxFit.cover,
          height: 40,
        ),
        backgroundColor: AppConstants.appBarColor,
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
      // drawer: DrawerMenu(),
      // drawerEdgeDragWidth: 0,
      floatingActionButton: NewItemFab(
        color: AppConstants.appBarColor,
        initIsToday: false,
      ),
    );
  }

  _buildNote(String text, Color backgroundColor, Color textColor) {
    return Ink(
        color: backgroundColor,
        height: AppConstants.headerHeight / 2,
        child: Container(
          alignment: Alignment(0.0, 0.0),
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ));
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FutureBuilder(
          future: appState.storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<ToDoItem> todayItems;
            List<ToDoItem> backlogItems;
            int completedCount;
            //var formatter = new DateFormat.MMMMEEEEd();
            // Widget headerText = Text(
            //   DateFormat.MMMMEEEEd().format(DateTime.now()),
            //   style: TextStyle(color: Colors.white),
            // );

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[DateHeader(), CircularProgressIndicator()],
              );
            }

            appState.initialize();
            todayItems = appState.allTodayItems;
            backlogItems = appState.allToDoItems;
            completedCount = appState.allCompletedTodayItems.length;

            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DateHeader(),
                      NoteHeader(
                        text: "${todayItems.length.toString()} things to focus on...",
                        backgroundColor: Color(0xFF247BA0),
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                ToDoList(
                  items: todayItems,
                  pageType: PageType.today,
                ),
                // SliverToBoxAdapter(
                //   child: Container(
                //     child: Text("data"),
                //   ),
                // ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: false,
                  child: Container(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      NoteHeader(
                        text:
                            "${backlogItems.length.toString()} others left to do...",
                      ),
                    ],
                  ),
                ),
                ToDoList(
                  items: backlogItems,
                  pageType: PageType.today,
                ),
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
