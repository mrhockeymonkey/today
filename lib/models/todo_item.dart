import 'package:flutter/material.dart';

class ToDoItem {
  String title;
  UniqueKey key = UniqueKey();
  bool isComplete = false;
  bool isToday = false;
  bool isScheduled = false;

  ToDoItem({
    @required this.title,
  });

  ToDoItem.complete({
    @required this.title,
    @required this.isComplete,
    @required this.isToday,
    @required this.isScheduled,
  });

  Map<String, dynamic> toJsonEncodable() {
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['isComplete'] = isComplete;
    m['isToday'] = isToday;
    m['isScheduled'] = isScheduled;

    return m;
  }
}
