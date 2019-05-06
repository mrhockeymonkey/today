import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/widgets/todo_list.dart';

class CompletedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompletedPageState();
  }
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  Widget build(BuildContext context) {
    AppConstants.changeStatusColor(AppConstants.laterColor);

    return Scaffold(
      appBar: AppBar(
        title: Text("Completed"),
        backgroundColor: AppConstants.laterColor,
        elevation: 0.0,
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            appState.initialize();
            items = appState.allCompletedItems;
            Color completedColor = AppConstants.laterColor;

            return Column(
              children: <Widget>[
                CategoryHeader(
                  headerColor: completedColor,
                  headerCount: items.length,
                ),
                ToDoList(
                  items: items,
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
