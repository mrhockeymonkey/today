import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './goals_page.dart';
import './settings_page.dart';
import '../models/app_constants.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import '../widgets/date_header.dart';
import '../widgets/note_header.dart';
import '../widgets/tdl_base.dart';
import '../widgets/tdl_primary.dart';
import '../widgets/new_item_fab.dart';

class TodayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TodayPageState();
  }
}

class _TodayPageState extends State<TodayPage> {
  bool foo = false;

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
            List<ToDoItem> dueItems;
            List<ToDoItem> backlogItems;
            List<ToDoItem> goalItems;
            Map<int, ToDoItem> goals;

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[DateHeader(), CircularProgressIndicator()],
              );
            }

            appState.initialize();
            goals = appState.goals;
            goalItems = goals.values.toList();
            dueItems = appState.allDueItemsExcludingGoals;
            backlogItems = appState.allToDoItemsExcludingGoals;

            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DateHeader(),
                      NoteHeader(
                        text: "${goalItems.length} items to focus on...",
                        backgroundColor: Color(0xFF247BA0),
                        textColor: Colors.white,
                      )
                    ],
                  ),
                ),
                TdlPrimary(
                  items: goalItems,
                  pageType: PageType.today,
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    child: FlatButton(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Edit Goals...",
                          textAlign: TextAlign.left,
                          style: TextStyle(color: AppConstants.appBarColor),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return GoalsPage(
                                goals: goals,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  )
                ])),
                _buildDueItemsHeader(dueItems),
                _buildDueItemsList(dueItems),
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
                            "${backlogItems.length.toString()} thing to do...",
                        textColor: Colors.white,
                        backgroundColor: Color(0xFF247BA0),
                      ),
                    ],
                  ),
                ),
                TdlPrimary(
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

  Widget _buildDueItemsHeader(List<ToDoItem> dueItems) {
    return SliverList(
        delegate: dueItems.length > 0
            ? SliverChildListDelegate(
                [
                  NoteHeader(
                    text: "${dueItems.length.toString()} new things due...",
                    textColor: Colors.white,
                    backgroundColor: Color(0xFF247BA0),
                  ),
                ],
              )
            : SliverChildListDelegate([]));
  }

  Widget _buildDueItemsList(List<ToDoItem> dueItems) {
    return dueItems.length <= 0
        ? SliverList(
            delegate: SliverChildListDelegate([]),
          )
        : TdlPrimary(
            items: dueItems,
            pageType: PageType.todo,
          );
  }
}
