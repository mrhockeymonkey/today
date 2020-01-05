import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_constants.dart';
import '../widgets/category_header.dart';
import '../models/app_state.dart';
import '../models/todo_item.dart';
import '../widgets/todo_list.dart';
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
        title: Text("5 Things"),
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
            items = appState.allCompletedItems;

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
                  pageType: PageType.completed,
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
            //       pageType: PageType.completed,
            //     ),
            //   ],
            // );
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
