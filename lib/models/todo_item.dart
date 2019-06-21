import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoItem {
  String title;
  UniqueKey key = UniqueKey();
  bool isComplete = false;
  bool isToday = false;
  DateTime _scheduledDate;

  ToDoItem({
    @required this.title,
  }) {
    _scheduledDate = DateTime.fromMillisecondsSinceEpoch(0);
  }

  ToDoItem.fromStorage({
    @required this.title,
    @required this.isComplete,
    @required this.isToday,
    scheduledMilliseconds,
  }) {
    _scheduledDate =
        DateTime.fromMillisecondsSinceEpoch(scheduledMilliseconds ?? 0);
  }

  //---------- getter/setter for scheduledDate
  DateTime get scheduledDate {
    return _scheduledDate;
  }

  set scheduledDate(DateTime date) {
    //_scheduledDate = DateTime(date.year, date.month, date.day);
    _scheduledDate = date;
  }

  //--------- helper methods for conditionals
  bool get isScheduled {
    if (_scheduledDate.millisecondsSinceEpoch > 0 && !isComplete) {
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
    // done using sortable integer of format yyyymmdd 
    if (!isScheduled) {
      return false;
    } else {
      var now = DateTime.now();
      int todaySortable = int.parse(
          now.year.toString() + now.month.toString() + now.day.toString());
      int scheduledSortable = int.parse(_scheduledDate.year.toString() +
          _scheduledDate.month.toString() +
          _scheduledDate.day.toString());

      if (scheduledSortable < todaySortable) {
        return true;
      } else {
        return false;
      }
    }
  }

  int get daysOverdue {
    var now = DateTime.now();
    var diff = now.difference(_scheduledDate);
    return diff.inDays;
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
    m['isToday'] = isToday;
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
    isToday = true;
    key = UniqueKey();
  }

  void markScheduled(DateTime newScheduledDate) {
    print("marking $title as scheduled");
    scheduledDate = newScheduledDate;
    isToday = false;
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
