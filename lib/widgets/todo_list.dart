import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../models/app_constants.dart';
import '../models/todo_item.dart';
import '../models/app_state.dart';
import '../pages/item_page.dart';
import '../models/category.dart';

// we want different swipe action and backgrounds based on the type of page
enum PageType {
  todo,
  later,
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

class _ToDoListState extends State<ToDoList> with WidgetsBindingObserver {
  //---------- required to use WidgetsBindingObserver
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //---------- override the system back button
  @override
  didPopRoute() {
    // didPopRoute called when back button is hit
    // in this case we pop the top route ourselves becuase it is part of a different stack
    Navigator.pop(context);
    return new Future<bool>.value(true);
  }

  //---------- build method
  @override
  Widget build(BuildContext context) {
    print("BUILD - todo_list");
    return SliverFixedExtentList(
      itemExtent: 72.0,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        ToDoItem item = widget.items[index];
        Future<bool> _confirmDismiss(DismissDirection direction) async {
          if (direction == DismissDirection.startToEnd &&
              widget.pageType == PageType.completed) {
            return false;
          } else if (direction == DismissDirection.endToStart &&
              widget.pageType == PageType.todo) {
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
              _buildListTile(item, index, widget.pageType),
            ],
          ),
        );
      }, childCount: widget.items.length),
    );
  }
  // //---------- build method
  // @override
  // Widget build(BuildContext context) {
  //   print("BUILD - todo_list");
  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: widget.items.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         ToDoItem item = widget.items[index];
  //         Future<bool> _confirmDismiss(DismissDirection direction) async {
  //           if (direction == DismissDirection.startToEnd &&
  //               widget.pageType == PageType.completed) {
  //             return false;
  //           } else if (direction == DismissDirection.endToStart &&
  //               widget.pageType == PageType.todo) {
  //             return false;
  //           } else {
  //             return true;
  //           }
  //         }

  //         return Dismissible(
  //           key: item.key,
  //           direction: DismissDirection.horizontal,
  //           confirmDismiss: (DismissDirection direction) =>
  //               _confirmDismiss(direction),
  //           onDismissed: (DismissDirection direction) =>
  //               _handleOnDismissed(direction, item),
  //           background: _buildBackground(widget.pageType, item),
  //           secondaryBackground: _buildSecondaryBackground(widget.pageType),
  //           child: Column(
  //             children: <Widget>[
  //               _buildListTile(item),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  //---------- helper methods
  void _handleOnDismissed(DismissDirection direction, ToDoItem item) {
    // handle onDismiss >>
    if (direction == DismissDirection.startToEnd) {
      setState(() {
        switch (widget.pageType) {
          case PageType.todo:
            // AppState appState = ScopedModel.of<AppState>(context);
            // if (appState.isTodayFull) {
            //   _snackBarMsg(
            //     "You already have 5 things to focus on",
            //     Icon(Icons.error_outline, color: AppConstants.todoColor),
            //   );
            // }
            item.markToday();
            break;
          case PageType.later:
            // AppState appState = ScopedModel.of<AppState>(context);
            // if (appState.isTodayFull) {
            //   _snackBarMsg(
            //     "You already have 5 things to focus on",
            //     Icon(Icons.error_outline, color: AppConstants.todoColor),
            //   );
            // }
            item.markToday();
            break;
          case PageType.today:
            DateTime next;

            if (item.isRecurring) {
              Jiffy now = Jiffy();

              switch (item.repeatLen) {
                case 'days':
                  next = now.add(days: item.repeatNum);
                  break;
                case 'weeks':
                  next = now.add(weeks: item.repeatNum);
                  break;
                case 'months':
                  next = now.add(months: item.repeatNum);
                  break;
              }
              int intNext = ToDoItem.toSortableDate(next);
              item.markScheduled(intNext);
              _snackBarMsg(
                "Repeats on " + DateFormat.MMMMEEEEd().format(next),
                Icon(Icons.repeat, color: AppConstants.todoColor),
              );

              // Scaffold.of(context).showSnackBar(
              //   SnackBar(
              //     content: Row(
              //       children: <Widget>[
              //         Icon(
              //           Icons.repeat,
              //           color: AppConstants.todoColor,
              //         ),
              //         Text(
              //             " Repeats on " + DateFormat.MMMMEEEEd().format(next)),
              //       ],
              //     ),
              //   ),
              // );
            } else {
              item.markCompleted();
            }
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
          case PageType.todo:
            break; // nothing to do
          case PageType.later:
            item.markScheduled(0); // 0 effectively being unscheduled
            break;
          case PageType.today:
            DateTime tomorrow = DateTime.now().add(Duration(days: 1));
            int intTomorrow = ToDoItem.toSortableDate(tomorrow);
            item.markScheduled(intTomorrow);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.done,
                      color: AppConstants.completeColor,
                    ),
                    Text(" Scheduled " +
                        DateFormat.MMMMEEEEd().format(tomorrow)),
                  ],
                ),
              ),
            );
            break;
          case PageType.completed:
            item.markUncompleted();
            break;
        }
        ScopedModel.of<AppState>(context).saveToStorage();
      });
    }
  }

  void _snackBarMsg(String message, Icon icon) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            icon,
            Text(" " + message),
          ],
        ),
      ),
    );
  }

  // determines the swipe right action background
  Widget _buildBackground(PageType type, ToDoItem item) {
    var align = MainAxisAlignment.start;
    switch (type) {
      case PageType.todo:
        return _buildTodayBackground(align);
      case PageType.later:
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
      case PageType.todo:
        return Container();
      case PageType.later:
        return _buildToDoBackground(align);
      case PageType.today:
        return _buildLaterBackground(align);
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

  Widget _buildToDoBackground(MainAxisAlignment align) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      //alignment: Alignment.centerRight,
      color: AppConstants.todoColor,
      child: Row(
        mainAxisAlignment: align,
        children: <Widget>[
          Icon(
            Icons.list,
            color: Colors.white,
          ),
          Text('BACKLOG')
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
          Text('TOMORROW')
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
          Text('DONE')
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

  // generates and pushes an item detail page for the tapped item
  void _pushItemPage(BuildContext context, ToDoItem item) {
    AppState appState = ScopedModel.of<AppState>(context);
    Category itemCategory;
    int categoryIndexToPush;
    int itemIndexToPush;

    // categories has a seperate navigator so we must find the root
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) {
          // categoryIndex and itemIndex are required to build the item detail page
          categoryIndexToPush = appState.categoryIndexOf(item);
          itemCategory = appState.categories[categoryIndexToPush];
          itemIndexToPush = itemCategory.items.indexOf(item);

          // return item detail page
          return ItemPage(
            categoryIndex: categoryIndexToPush,
            itemIndex: itemIndexToPush,
            initIsToday: false,
            focusKeyboard: false,
          );
        },
      ),
    );
  }

  Widget _buildFocusTile(ToDoItem item, List<Widget> subtitles, Category category) {
    AppState appState = ScopedModel.of<AppState>(context);
    int categoryIndex = appState.categoryIndexOf(item);
    List<IconData> fiveIcons = [
      Entypo.flag, //must do
      Entypo.game_controller, //want to
      Entypo.pin, //should do
      Entypo.pin, //could do
      Entypo.info //fyi
    ];
    return ListTile(
      title: Text(item.title),
      leading: Icon(
        // Entypo.pin,
        // Entypo.forward,
        fiveIcons[categoryIndex],
        color: category.color,
      ),
      subtitle: Row(
        children: subtitles,
      ),
      onTap: () => _pushItemPage(context, item),
    );
  }

  Widget _buildSwipeLeftTile(ToDoItem item, List<Widget> subtitles, Category category) {
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(color: AppConstants.completedColor),
      ),
      trailing: Icon(
        Entypo.reply,
        color: category.color,
      ),
      subtitle: Row(
        children: subtitles,
      ),
      onTap: () => _pushItemPage(context, item),
    );
  }

  Widget _buildSwipeRightTile(ToDoItem item, List<Widget> subtitles, Category category) {
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(color: AppConstants.completedColor),
      ),
      leading: Icon(
        Entypo.forward,
        color: category.color,
      ),
      subtitle: Row(
        children: subtitles,
      ),
      onTap: () => _pushItemPage(context, item),
    );
  }

  Widget _buildCompletedTile(ToDoItem item, List<Widget> subtitles) {
    return Ink(
      color: AppConstants.completedColor,
      child: ListTile(
        title: Text(
          item.title,
          style: TextStyle(decoration: TextDecoration.lineThrough),
        ),
        subtitle: Text("DONE"),
        trailing: Icon(Icons.done_all),
      ),
    );
  }

  Widget _buildListTile(ToDoItem item, int index, PageType pageType) {
    AppState appState = ScopedModel.of<AppState>(context);
    int categoryIndex = appState.categoryIndexOf(item);
    Category itemCategory = appState.categories[categoryIndex];
    List<Widget> subtitleElements = [];

    // first build the subtitle
    subtitleElements.add(
      Text(
        itemCategory.name.toUpperCase(),
        style: TextStyle(
          color: itemCategory.color,
        ),
      ),
    );

    if (item.isOverDue) {
      subtitleElements.add(
        Text(
          " - ${item.daysOverdue} days ago",
          //style: TextStyle(background: Paint()),
        ),
      );
    } else if (item.isScheduled) {
      subtitleElements.add(
        Text(" - " + item.dateFormattedStr),
      );
    }

    switch (pageType) {
      case PageType.todo:
        return _buildSwipeRightTile(item, subtitleElements, itemCategory);
      case PageType.later:
        return _buildSwipeRightTile(item, subtitleElements, itemCategory);
      case PageType.today:
        if (index < 5) {
          return _buildFocusTile(item, subtitleElements, itemCategory);
        } else {
          return _buildSwipeLeftTile(item, subtitleElements, itemCategory);
        }
        break;
      case PageType.completed:
        return _buildCompletedTile(item, subtitleElements);
    }
  }
}
