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

abstract class TdlBase extends StatefulWidget {
  final List<ToDoItem> items;
  final PageType pageType;

  TdlBase({
    @required this.items,
    @required this.pageType,
  });
}

// abstract class BaseState<Page extends BasePage> extends State<Page>
abstract class TdlBaseState<Tdl extends TdlBase> extends State<TdlBase>
    with WidgetsBindingObserver {
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
          background: buildBackground(),
          secondaryBackground: buildSecondaryBackground(),
          child: Column(
            children: <Widget>[
              _buildList(item, index, widget.pageType),
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

  // create the swipe right action background (override)
  Widget buildBackground() {
    return Container();
  }

  // create the swipe right action background (override)
  Widget buildSecondaryBackground() {
    return Container();
  }

  // generates and pushes an item detail page for the tapped item
  void pushItemPage(BuildContext context, ToDoItem item) {
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
            focusKeyboard: false,
          );
        },
      ),
    );
  }

  Widget buildListTile(ToDoItem item, Category category, int categoryIndex) {
    return ListTile(
      title: Text("Default List Tile"),
    );
  }

  Widget _buildList(ToDoItem item, int index, PageType pageType) {
    AppState appState = ScopedModel.of<AppState>(context);
    int categoryIndex = appState.categoryIndexOf(item);
    Category itemCategory = appState.categories[categoryIndex];
    return buildListTile(item, itemCategory, categoryIndex);
  }
}
