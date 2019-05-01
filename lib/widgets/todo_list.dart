import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';

class ToDoList extends StatefulWidget {
  final List<ToDoItem> items;

  ToDoList({@required this.items});

  @override
  State<StatefulWidget> createState() {
    return _ToDoListState();
  }
}

class _ToDoListState extends State<ToDoList> {
  @override
  Widget build(BuildContext context) {
    return _buildTodoList();
  }

  Widget _buildTodoList() {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          ToDoItem item = widget.items[index];
          print("item: " +
              item.title +
              " complete-" +
              item.isComplete.toString() +
              " today-" +
              item.isComplete.toString());
          // Future<bool> _confirmDissmiss(DismissDirection direction) async {
          //   if (direction == DismissDirection.startToEnd) {
          //     print('>');
          //     item.isComplete = true;

          //     setState(() {});
          //   } else {
          //     print('<');
          //     item.isToday = true;
          //     setState(() {});
          //   }
          //   return false;
          // }

          return Dismissible(
            key: item.key,
            direction: DismissDirection.horizontal,
            onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  item.markCompleted();
                  ScopedModel.of<AppState>(context).saveToStorage();
                });
              } else {
                setState(() {
                  item.markToday();
                  ScopedModel.of<AppState>(context).saveToStorage();
                });
              }
            },
            background: _buildTodoBackground(), //_buildCompleteBackground(),
            secondaryBackground: _buildLaterBackground(),
            child: Column(
              children: <Widget>[
                _buildListTile(item),

                ///Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTodayBackground() {
    return Container(
      padding: EdgeInsetsDirectional.only(end: 15.0),
      alignment: Alignment.centerRight,
      color: Color(0xFF6A88BA),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Text('TODAY')
        ],
      ),
    );
  }

  Widget _buildLaterBackground() {
    return Container(
      padding: EdgeInsetsDirectional.only(end: 15.0),
      alignment: Alignment.centerRight,
      color: AppConstants.laterColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(),
          ),
          Icon(
            Icons.today,
            color: Colors.white,
          ),
          Text('LATER')
        ],
      ),
    );
  }

  Widget _buildCompleteBackground() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 15.0),
      alignment: Alignment.centerLeft,
      color: AppConstants.completeColor,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.done,
            color: Colors.white,
          ),
          Text('COMPLETE')
        ],
      ),
    );
  }

  Widget _buildTodoBackground() {
    return Container(
      padding: EdgeInsetsDirectional.only(start: 15.0),
      alignment: Alignment.centerLeft,
      color: AppConstants.todoColor,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.restore,
            color: Colors.white,
          ),
          Text('TO DO')
        ],
      ),
    );
  }

  Widget _buildListTile(ToDoItem item) {
    if (item.isComplete) {
      return Ink(
        color: Colors.grey,
        child: ListTile(
          title: Text(
            item.title,
            style: TextStyle(decoration: TextDecoration.lineThrough),
          ),
          trailing: Text('complete'),
        ),
      );
    } else if (item.isToday) {
      return ListTile(
        title: Text(item.title),
        trailing: Text('today'),
      );
    } else {
      return ListTile(
        title: Text(item.title),
      );
    }
  }
}
