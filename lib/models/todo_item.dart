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

  DateTime get scheduledDate {
    return _scheduledDate;
  }

  set scheduledDate(DateTime date) {
    // we exclude the concept of time and focus only on dates
    _scheduledDate = DateTime(date.year, date.month, date.day);
  }

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

  bool get isOverDue {
    // calculate the difference in time from now
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);
    var diffInDays = today.difference(_scheduledDate).inDays;
    if (diffInDays >= 1) {
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

  void update(String newTitle, DateTime newScheduledDate) {
    title = newTitle;
    scheduledDate = newScheduledDate;
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

  void markScheduled(DateTime newScheduledDate) {
    print("marking $title as scheduled");
    scheduledDate = newScheduledDate;
    _todayDate = DateTime.fromMillisecondsSinceEpoch(0);
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
