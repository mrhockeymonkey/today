import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'dart:math' as math;
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
              widget.pageType == PageType.later) {
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

  //---------- helper methods
  void _handleOnDismissed(DismissDirection direction, ToDoItem item) {
    // handle onDismiss >>
    if (direction == DismissDirection.startToEnd) {
      setState(() {
        bool shouldMarkComplete = true;

        if (widget.pageType == PageType.todo ||
            widget.pageType == PageType.today) {
          // if the item is a series decrement the occurences left
          if (item.isSeries) {
            shouldMarkComplete = false;
            if (item.seriesLen == 1) {
              shouldMarkComplete = true;
              item.seriesLen = 0;
              _snackBarMsg(
                "Series completed",
                Icon(Icons.slideshow, color: AppConstants.todoColor),
              );
            } else {
              item.seriesLen = item.seriesLen - 1;
              _snackBarMsg(
                "${item.seriesLen} occurrences left in series",
                Icon(Icons.slideshow, color: AppConstants.todoColor),
              );
            }
          }

          // if item is recurring calculate and set next scheduled date
          if (item.isRecurring) {
            shouldMarkComplete = false;
            Jiffy now = Jiffy();
            DateTime next;
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
              "Repeats in ${item.repeatNum} ${item.repeatLen}",
              Icon(Icons.repeat, color: AppConstants.todoColor),
            );
          }

          if (shouldMarkComplete) {
            item.markCompleted();
          }
        } else if (widget.pageType == PageType.later) {
          item.markToday();
        }

        ScopedModel.of<AppState>(context).saveToStorage();
      });
    }
    // handle onDismiss <<
    else {
      setState(() {
        if (widget.pageType == PageType.todo ||
            widget.pageType == PageType.today) {
          // snooze for 1 day
          DateTime tomorrow = DateTime.now().add(Duration(days: 1));
          int intTomorrow = ToDoItem.toSortableDate(tomorrow);
          item.markScheduled(intTomorrow);
          _snackBarMsg(
            "Scheduled for tomorrow",
            Icon(Icons.today, color: AppConstants.todoColor),
          );
        } else if (widget.pageType == PageType.completed) {
          // return to to do list
          item.markUncompleted();
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
    Widget background;

    switch (type) {
      case PageType.todo:
        background = _buildCompleteBackground(align);
        break;
      case PageType.later:
        background = _buildTodayBackground(align);
        break;
      case PageType.today:
        background = _buildCompleteBackground(align);
        break;
      case PageType.completed:
        background = _buildDeleteBackground(align);
        break;
    }
    return background;
  }

  // determines the swipe left action background
  Widget _buildSecondaryBackground(PageType type) {
    var align = MainAxisAlignment.end;
    Widget background;

    switch (type) {
      case PageType.todo:
        background = _buildLaterBackground(align);
        break;
      case PageType.later:
        background = Container();
        break;
      case PageType.today:
        background = _buildLaterBackground(align);
        break;
      case PageType.completed:
        background = _buildUncompleteBackground(align);
        break;
    }
    return background;
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

  Widget _buildFocusTile(
    ToDoItem item,
    List<Widget> subtitles,
    Category category,
  ) {
    AppState appState = ScopedModel.of<AppState>(context);
    int categoryIndex = appState.categoryIndexOf(item);

    return ListTile(
      title: Text(item.title),
      leading: Icon(
        AppConstants.categoryIcons[categoryIndex],
        color: category.color,
      ),
      subtitle: Row(
        children: subtitles,
      ),
      onTap: () => _pushItemPage(context, item),
    );
  }

  Widget _buildUnfocusedTile(
    ToDoItem item,
    List<Widget> subtitles,
    Category category,
  ) {
    AppState appState = ScopedModel.of<AppState>(context);
    int categoryIndex = appState.categoryIndexOf(item);

    return ListTile(
      title: Text(item.title),
      leading: Icon(
        AppConstants.categoryIcons[categoryIndex],
        color: Colors.grey,
      ),
      subtitle: Row(
        children: subtitles,
      ),
      // trailing: IconButton(
      //   icon: Transform.rotate(
      //     angle: 90 * math.pi / 180,
      //     child: Icon(
      //       Entypo.reply,
      //       color: category.color,
      //     ),
      //   ),
      //   onPressed: () {},
      // ),
      onTap: () => _pushItemPage(context, item),
    );
  }

  Widget _buildScheduledTile(
      ToDoItem item, List<Widget> subtitles, Category category) {
    return ListTile(
      title: Text(item.title),
      leading: Icon(
        Entypo.hour_glass,
        color: category.color,
      ),
      subtitle: Row(
        children: subtitles,
      ),
      onTap: () => _pushItemPage(context, item),
    );
  }

  Widget _buildCompletedTile(ToDoItem item, Category category) {
    return ListTile(
      title: Text(
        item.title,
        style: TextStyle(decoration: TextDecoration.lineThrough),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            "DONE",
            style: TextStyle(color: category.color),
          ),
          Text(" - "),
          Icon(
            Icons.done,
            color: category.color,
            size: 15,
          ),
          Text(" ${item.completedDateFormattedStr}"),
        ],
      ),
      leading: Icon(
        Icons.done,
        color: category.color,
      ),
    );
  }

  Widget _buildListTile(ToDoItem item, int index, PageType pageType) {
    AppState appState = ScopedModel.of<AppState>(context);
    int categoryIndex = appState.categoryIndexOf(item);
    Category itemCategory = appState.categories[categoryIndex];
    List<Widget> subtitleElements = [];
    List<Widget> subtitleIndicators = [];
    Widget listTile;

    // first build the subtitle
    subtitleElements.add(
      Text(
        "${itemCategory.name.toUpperCase()}",
        style: TextStyle(
          color: itemCategory.color,
        ),
      ),
    );

    // add any indicators needed
    if (item.isOverDue || item.isScheduled) {
      subtitleIndicators.add(
        Icon(
          Icons.today,
          color: itemCategory.color,
          //color: Colors.grey,
          size: 15.0,
        ),
      );
      if (item.isOverDue) {
        subtitleIndicators.add(
          Text(
            " ${item.daysOverdue} days ago ",
            //style: TextStyle(background: Paint()),
          ),
        );
      } else if (item.isScheduled) {
        subtitleIndicators.add(
          Text(" ${item.scheduledDateFormattedStr} "),
        );
      }
    }

    if (item.isRecurring) {
      subtitleIndicators.add(
        Icon(
          Icons.repeat,
          color: itemCategory.color,
          //color: Colors.grey,
          size: 15.0,
        ),
      );
      subtitleIndicators.add(
        Text(" ${item.repeatNum}${item.repeatLen[0]} "),
      );
    }

    if (item.isSeries) {
      subtitleIndicators.add(
        Icon(
          Icons.slideshow,
          color: itemCategory.color,
          //color: Colors.grey,
          size: 15.0,
        ),
      );
      subtitleIndicators.add(
        Text(" ${item.seriesLen} left"),
      );
    }

    // join indicators to subtitle
    if (subtitleIndicators.length > 0) {
      subtitleElements.add(
        Text(" - "),
      );
      subtitleElements.addAll(subtitleIndicators);
    }

    switch (pageType) {
      case PageType.todo:
        listTile = _buildUnfocusedTile(item, subtitleElements, itemCategory);
        break;
      case PageType.later:
        listTile = _buildScheduledTile(item, subtitleElements, itemCategory);
        break;
      case PageType.today:
        listTile = _buildFocusTile(item, subtitleElements, itemCategory);
        break;
      case PageType.completed:
        listTile = _buildCompletedTile(item, itemCategory);
        break;
    }

    return listTile;
  }
}
