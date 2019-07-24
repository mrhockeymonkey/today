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
    var nowSortable = ToDoItem.toSortableDate(DateTime.now());
    var scheduledSortable = ToDoItem.toSortableDate(_scheduledDate);
    var zero = DateTime.fromMillisecondsSinceEpoch(0);

    if (scheduledSortable.isBefore(nowSortable) && _scheduledDate != zero) {
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
      var todaySortable = ToDoItem.toSortableDate(now);
      // now.toint.parse(
      //    now.year.toString() + now.month.toString() + now.day.toString());
      var scheduledSortable = ToDoItem.toSortableDate(_scheduledDate);
      // int.parse(_scheduledDate.year.toString() +
       //   _scheduledDate.month.toString() +
       //   _scheduledDate.day.toString());

      if (scheduledSortable.isBefore(todaySortable)) {
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

  static DateTime toSortableDate(DateTime date) {
    DateTime sortable = DateTime(date.year, date.month, date.day);
    // int sortable = int.parse(date.year.toString() +
    //       date.month.toString() +
    //       date.day.toString());
    return sortable;
  }

  void update(String newTitle, DateTime newScheduledDate) {
    title = newTitle;
    scheduledDate = newScheduledDate;
  }

  void markCompleted() {
    print("marking $title as completed");
    isComplete = true;
    isToday = false;
    _scheduledDate = DateTime.fromMillisecondsSinceEpoch(0);
    //key = UniqueKey();
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
