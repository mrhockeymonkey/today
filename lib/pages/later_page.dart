import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:today/widgets/note_header.dart';

import '../models/app_constants.dart';
import '../widgets/date_header.dart';
//import '../widgets/note_header.dart';
import '../widgets/tdl_base.dart';
import '../widgets/tdl_scheduled.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import './settings_page.dart';
// import '../models/todo_category.dart';
// import '../models/todo_item.dart';
// import '../pages/item_page.dart';

class LaterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LaterPageState();
  }
}

class _LaterPageState extends State<LaterPage> {
  Color headerColor = AppConstants.laterHeaderColor;

  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(AppConstants.laterColor);

    print("Build: later page");
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
        body: _buildBody()
        //floatingActionButton: _buildFloatingActionButton(),
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
                children: <Widget>[DateHeader(), CircularProgressIndicator()],
              );
            }

            appState.initialize();
            items = appState.allScheduledItems;

            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      DateHeader(),
                      NoteHeader(
                        text: "${items.length.toString()} things coming up...",
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                ),
                TdlScheduled(
                  items: items,
                  pageType: PageType.later,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
