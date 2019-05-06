import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';

// we want different swipe action and backgrounds based on the type of page
enum PageType {
  later,
  category,
  today,
  completed,
}

class ToDoList extends StatefulWidget {
  final List<ToDoItem> items;
  final PageType pageType;

  ToDoList({
    @required this.items,
    @required this.pageType,
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
          Future<bool> _confirmDismiss(DismissDirection direction) async {
            if (direction == DismissDirection.startToEnd &&
                widget.pageType == PageType.completed) {
              return false;
            } else {
              return true;
            }
          }

          return Dismissible(
            key: item.key,
            direction: DismissDirection.horizontal,
            confirmDismiss: (DismissDirection direction) =>
                _confirmDismiss(direction),
            onDismissed: (DismissDirection direction) =>
                _handleOnDismissed(direction, item),
            background: _buildBackground(widget.pageType, item),
            secondaryBackground: _buildSecondaryBackground(widget.pageType),
            child: Column(
              children: <Widget>[
                _buildListTile(item),
              ],
            ),
          );
        },
      ),
    );
  }

  // determines what needs to occur on dismiss
  void _handleOnDismissed(DismissDirection direction, ToDoItem item) {
    // handle onDismiss >>
    if (direction == DismissDirection.startToEnd) {
      setState(() {
        switch (widget.pageType) {
          case PageType.later:
            item.markToday();
            break;
          case PageType.category:
            item.markToday();
            break;
          case PageType.today:
            item.markCompleted();
            break;
          case PageType.completed:
            break; //nothing to do
        }
        ScopedModel.of<AppState>(context).saveToStorage();
      });
    }
    // handle onDismiss <<
    else {
      setState(() {
        switch (widget.pageType) {
          case PageType.later:
            item.markScheduled(DateTime.now());
            break;
          case PageType.category:
            item.markScheduled(DateTime.now());
            break;
          case PageType.today:
            item.markUncompleted();
            break;
          case PageType.completed:
            item.markUncompleted();
            break;
        }
        ScopedModel.of<AppState>(context).saveToStorage();
      });
    }
  }

  // determines the swipe right action background
  Widget _buildBackground(PageType type, ToDoItem item) {
    var align = MainAxisAlignment.start;
    switch (type) {
      case PageType.later:
        return _buildTodayBackground(align);
      case PageType.category:
        return _buildTodayBackground(align);
      case PageType.today:
        return _buildCompleteBackground(align);
      case PageType.completed:
        return _buildDeleteBackground(align);
    }
  }

  // determines the swipe left action background
  Widget _buildSecondaryBackground(PageType type) {
    var align = MainAxisAlignment.end;
    switch (type) {
      case PageType.later:
        return Container();
      case PageType.category:
        return _buildLaterBackground(align);
      case PageType.today:
        return _buildUncompleteBackground(align);
      case PageType.completed:
        return _buildUncompleteBackground(align);
    }
  }

  Widget _buildTodayBackground(MainAxisAlignment align) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      //alignment: Alignment.centerRight,
      color: Color(0xFF6A88BA),
      child: Row(
        mainAxisAlignment: align,
        children: <Widget>[
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          Text('TODAY')
        ],
      ),
    );
  }

  Widget _buildLaterBackground(MainAxisAlignment align) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      //alignment: Alignment.centerRight,
      color: AppConstants.laterColor,
      child: Row(
        mainAxisAlignment: align,
        children: <Widget>[
          Icon(
            Icons.today,
            color: Colors.white,
          ),
          Text('LATER')
        ],
      ),
    );
  }

  Widget _buildCompleteBackground(MainAxisAlignment align) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      //alignment: Alignment.centerLeft,
      color: AppConstants.completeColor,
      child: Row(
        mainAxisAlignment: align,
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

  Widget _buildDeleteBackground(MainAxisAlignment align) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      //alignment: Alignment.centerLeft,
      color: Colors.red,
      child: Row(
        mainAxisAlignment: align,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text('DELETE')
        ],
      ),
    );
  }

  Widget _buildUncompleteBackground(MainAxisAlignment align) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      //alignment: Alignment.centerLeft,
      color: AppConstants.todoColor,
      child: Row(
        mainAxisAlignment: align,
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

    Widget completeTile = Ink(
      color: AppConstants.completedColor,
      child: ListTile(
        title: Text(
          item.title,
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
        trailing: Icon(Icons.done_all),
      ),
    );

    Widget normalTile = ListTile(
      title: Text(item.title),
      subtitle: item.isScheduled ? Text(item.dateFormattedStr): Container(),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          item.isToday ? Icon(Icons.done) : Container(),
          item.isScheduled ? Icon(Icons.today) : Container(),
        ],
      ),
    );

    if (item.isComplete) {
      return completeTile;
    } else {
      return normalTile;
    }
  }
}
