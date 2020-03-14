import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_constants.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import '../widgets/date_header.dart';
import '../widgets/note_header.dart';
import '../widgets/todo_list.dart';
import '../widgets/new_item_fab.dart';
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
      floatingActionButton: NewItemFab(
        color: AppConstants.appBarColor,
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
            List<ToDoItem> todayItems;
            List<ToDoItem> backlogItems;

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[DateHeader(), CircularProgressIndicator()],
              );
            }

            appState.initialize();
            todayItems = appState.allTodayItems;
            backlogItems = appState.allToDoItems;

            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DateHeader(),
                      todayItems.length > 5
                          ? NoteHeader(
                              text: "${todayItems.length.toString()} things to focus on...",
                              backgroundColor: Color(0xFFFBAF28),
                              textColor: Colors.black,
                            )
                          : NoteHeader(
                              text:
                                  "${todayItems.length.toString()} things to focus on...",
                              backgroundColor: Color(0xFF247BA0),
                              textColor: Colors.white,
                            )
                    ],
                  ),
                ),
                ToDoList(
                  items: todayItems,
                  pageType: PageType.today,
                ),
                SliverFillRemaining(
                  hasScrollBody: false,
                  fillOverscroll: false,
                  child: Container(),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      NoteHeader(
                        text: "${backlogItems.length.toString()} left to do...",
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                ToDoList(
                  items: backlogItems,
                  pageType: PageType.todo,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
