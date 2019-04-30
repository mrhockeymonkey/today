import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/todo_item.dart';

class ToDoList extends StatefulWidget {
  final List<ToDoItem> items;

  ToDoList({
    @required this.items
  });

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
          Future<bool> _confirmDissmiss(DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd) {
              print('>');
              item.isComplete = true;
              setState(() {});
            } else {
              print('<');
              item.isToday = true;
              setState(() {});
            }
            return false;
          }

          return Dismissible(
            key: item.key,
            direction: DismissDirection.horizontal,
            confirmDismiss: _confirmDissmiss,
            onDismissed: (DismissDirection direction) {},
            background: Container(
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
            ),
            secondaryBackground: Container(
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
            ),
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
