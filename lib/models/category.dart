import 'package:flutter/material.dart';

import '../models/todo_item.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Category {
  String name;
  final Color color;
  List<ToDoItem> _items = [];

  Category({
    @required this.name,
    @required this.color,
  });

  List<ToDoItem> get items {
    return List.from(_items);
  }

  int get leftToDoCount {
    return _items.where((i) => i.isComplete == false).length;
  }

  // getter for all items sorted by today,todo,done
  // List<ToDoItem> get itemsSorted {
  //   List<ToDoItem> _itemsTodo = _items
  //       .where((i) => (i.isComplete == false))
  //       .toList();
  //   List<ToDoItem> _itemsDone =
  //       _items.where((i) => i.isComplete == true).toList();
  //   List<ToDoItem> _itemsSorted =
  //       [_itemsTodoToday, _itemsTodo, _itemsDone].expand((x) => x).toList();
  //   return _itemsSorted;
  // }

  // getter for all todo items
  List<ToDoItem> get itemsToDo {
    List<ToDoItem> _itemsCompleted =
        _items.where((i) => !i.isComplete && !i.isScheduled).toList();
    return _itemsCompleted;
  }

  // getter for all completed items
  List<ToDoItem> get itemsCompleted {
    List<ToDoItem> _itemsCompleted = _items.where((i) => i.isComplete).toList();
    return _itemsCompleted;
  }

  // getter for all completed today items
  List<ToDoItem> get itemsCompletedToday {
    int intToday = ToDoItem.toSortableDate(DateTime.now());
    List<ToDoItem> _itemsCompleted = _items
        .where((i) => i.isComplete && i.completedDate == intToday)
        .toList();
    return _itemsCompleted;
  }

  // getter for all scheduled items
  List<ToDoItem> get itemsScheduled {
    List<ToDoItem> _itemsScheduled =
        _items.where((i) => i.isScheduled && !i.isDue).toList();
    return _itemsScheduled;
  }

  // getter for all due or overdue items
  List<ToDoItem> get itemsScheduledNowDue {
    List<ToDoItem> _filteredItems = _items.where((i) => i.isDue).toList();
    return _filteredItems;
  }

  void addItem(ToDoItem item) {
    _items.add(item);
  }

  void updateItem(
    int itemIndex,
    String newTitle,
    bool newIsToday,
    int newScheduledDate,
    int newRepeatNum,
    String newRepeatLen,
    int newSeriesLen,
  ) {
    if (newTitle != null) {
      _items[itemIndex].title = newTitle;
    }
    if (newScheduledDate != null) {
      _items[itemIndex].scheduledDate = newScheduledDate;
    }
    if (newRepeatNum != null) {
      _items[itemIndex].repeatNum = newRepeatNum;
      _items[itemIndex].repeatLen = newRepeatLen;
    }
    if (newSeriesLen != null) {
      _items[itemIndex].seriesLen = newSeriesLen;
    }
  }

  void removeItem(ToDoItem item) {
    _items.remove(item);
  }

  Map<String, dynamic> toJsonEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['color'] = color.value;
    m['items'] = _items.map((i) => i.toJsonEncodable()).toList();

    return m;
  }
}
