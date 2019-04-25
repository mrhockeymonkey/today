import 'package:flutter/material.dart';

import 'package:today/models/todo_item.dart';

class Category {
  final String name;
  final Color color;
  List<ToDoItem> _items = [
    ToDoItem(title: 'my first item'),
    ToDoItem(title: 'my second item')
  ];

  Category({
    @required this.name,
    @required this.color,
  });

  List<ToDoItem> get items {
    return List.from(_items);
  }

  void addItem(ToDoItem item) {;
    _items.add(item);
  }

  void removeItem(ToDoItem item) {
    _items.remove(item);
  }
}
