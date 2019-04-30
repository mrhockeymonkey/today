import 'package:flutter/material.dart';

import 'package:today/models/todo_item.dart';

class Category {
  final String name;
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
  List<ToDoItem> get itemsSorted {
    List<ToDoItem> _itemsTodoToday = _items.where((i) => (i.isComplete == false) & (i.isToday == true)).toList();
    List<ToDoItem> _itemsTodo = _items.where((i) => (i.isComplete == false) & (i.isToday == false)).toList();
    List<ToDoItem> _itemsDone = _items.where((i) => i.isComplete == true).toList();
    List<ToDoItem> _itemsSorted = [_itemsTodoToday, _itemsTodo, _itemsDone].expand((x) => x).toList();
    return _itemsSorted;
  }

  // getter for all today items
  List<ToDoItem> get itemsToday {
    List<ToDoItem> _itemsToday = _items.where((i) => i.isToday == true).toList();
    return _itemsToday;
  }

  void addItem(ToDoItem item) {
    _items.add(item);
  }

  void removeItem(ToDoItem item) {
    _items.remove(item);
  }

  Map<String,dynamic> toJsonEncodable() {
    Map<String, dynamic> m = new Map();

    m['name'] = name;
    m['color'] = color.value;
    m['items'] = _items.map((i) => i.toJsonEncodable()).toList();

    return m;
  }


}
