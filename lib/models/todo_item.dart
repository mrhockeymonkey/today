import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoItem {
  String title;
  UniqueKey key = UniqueKey();
  bool isComplete = false;
  DateTime _todayDate;
  DateTime _scheduledDate;

  ToDoItem({
    @required this.title,
  }) {
    _todayDate = DateTime.fromMillisecondsSinceEpoch(0);
    _scheduledDate = DateTime.fromMillisecondsSinceEpoch(0);
  }

  ToDoItem.fromStorage({
    @required this.title,
    @required this.isComplete,
    todayMilliseconds,
    scheduledMilliseconds,
  }) {
    _todayDate = DateTime.fromMillisecondsSinceEpoch(todayMilliseconds ?? 0);
    _scheduledDate =
        DateTime.fromMillisecondsSinceEpoch(scheduledMilliseconds ?? 0);
  }

  // getters for items that are set to today based on the date
  bool get isToday {
    var now = DateTime.now();
    if (_todayDate.day == now.day &&
        _todayDate.month == now.month &&
        _todayDate.year == now.year) {
      return true;
    } else {
      return false;
    }
  }

  bool get isScheduled {
    if (_scheduledDate.millisecondsSinceEpoch > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool get isDue {
    var now = DateTime.now();
    var zero = DateTime.fromMillisecondsSinceEpoch(0);
    if (_scheduledDate.isBefore(now) && _scheduledDate != zero) {
      return true;
    } else {
      return false;
    }
  }

  String get dateFormattedStr {
    var formatter = new DateFormat('d MMM');
    String formatted = formatter.format(_scheduledDate);
    return formatted;
  }

  Map<String, dynamic> toJsonEncodable() {
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['isComplete'] = isComplete;
    m['todayMilliseconds'] = _todayDate.millisecondsSinceEpoch;
    m['scheduledMilliseconds'] = _scheduledDate.millisecondsSinceEpoch;

    return m;
  }

  void markCompleted() {
    print("marking $title as completed");
    isComplete = true;
    _scheduledDate = DateTime.fromMillisecondsSinceEpoch(0);
    key = UniqueKey();
  }

  void markToday() {
    print("marking $title as today");
    //isToday = true;
    _todayDate = DateTime.now();
    key = UniqueKey();
  }

  void markScheduled(DateTime when) {
    print("marking $title as scheduled");
    //isScheduled = true;
    _scheduledDate = DateTime.now();
    key = UniqueKey();
  }

  void markUncompleted() {
    print("marking $title as uncompleted");
    isComplete = false;
    //isToday = false;
    //isScheduled = false;
    key = UniqueKey();
  }
}
