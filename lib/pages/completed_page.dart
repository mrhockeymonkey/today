import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_constants.dart';
import '../widgets/date_header.dart';
import '../widgets/note_header.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import '../widgets/tdl_base.dart';
import '../widgets/tdl_done.dart';
import './settings_page.dart';

class CompletedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletedPageState();
  }
}

class _CompletedPageState extends State<CompletedPage> {
  Color headerColor = AppConstants.completedHeaderColor;

  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(AppConstants.laterColor);

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
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FutureBuilder(
          future: appState.storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<ToDoItem> completedItems;
            List<ToDoItem> completedTodayItems;

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[DateHeader(), CircularProgressIndicator()],
              );
            }

            appState.initialize();
            completedItems = appState.allCompletedItems;
            completedTodayItems = appState.allCompletedTodayItems;

            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DateHeader(),
                      NoteHeader(
                        text:
                            "${completedTodayItems.length.toString()} things done today...",
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                TdlDone(
                  items: completedTodayItems,
                  pageType: PageType.completed,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      NoteHeader(
                        text:
                            "${completedItems.length.toString()} done in total...",
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                TdlDone(
                  items: completedItems,
                  pageType: PageType.completed,
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.delete),
      backgroundColor: Colors.red,
      onPressed: () {
        setState(() {
          ScopedModel.of<AppState>(context).deleteCompletedItems();
        });
      },
    );
  }
}
