import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoItem {
  String title;
  UniqueKey key = UniqueKey();
  bool isComplete = false;
  bool isToday = false;
  int scheduledDate = 0;
  //DateTime _scheduledDate;

  ToDoItem({
    @required this.title,
  });
  // {
  //   _scheduledDate = 0;
  // }

  ToDoItem.fromStorage({
    @required this.title,
    @required this.isComplete,
    @required this.isToday,
    @required this.scheduledDate
    //scheduledMilliseconds,
  });
  // {
  //   _scheduledDate =
  //       DateTime.fromMillisecondsSinceEpoch(scheduledMilliseconds ?? 0);
  // }

  //---------- getter/setter for scheduledDate
  // DateTime get scheduledDate {
  //   return _scheduledDate;
  // }

  // set scheduledDate(DateTime date) {
  //   //_scheduledDate = DateTime(date.year, date.month, date.day);
  //   _scheduledDate = date;
  // }

  //--------- helper methods for conditionals
  bool get isScheduled {
    // if the scheduledDate value is anything but 0 consider it to be scheduled
    //if (_scheduledDate.millisecondsSinceEpoch > 0 && !isComplete) {
    if (scheduledDate > 0 && !isComplete) {
      return true;
    } else {
      return false;
    }
  }

  bool get isDue {
    // if the scheduledDate is in the past then consider it to be due
    var todaysDate = ToDoItem.toSortableDate(DateTime.now());
    //var scheduledSortable = ToDoItem.toSortableDate(_scheduledDate);
    //var zero = DateTime.fromMillisecondsSinceEpoch(0);

    //if (scheduledSortable.isBefore(nowSortable) && _scheduledDate != zero) {
    if (scheduledDate <= todaysDate && scheduledDate > 0) {
      return true;
    } else {
      return false;
    }
  }

  // REMOVE?
  bool get isOverDue {
    // calculate the difference in time from now
    // done using sortable integer of format yyyymmdd 
    if (!isScheduled) {
      return false;
    } else {
      //var now = DateTime.now();
      //var todaySortable = ToDoItem.toSortableDate(now);
      // now.toint.parse(
      //    now.year.toString() + now.month.toString() + now.day.toString());
      //var scheduledSortable = ToDoItem.toSortableDate(_scheduledDate);
      // int.parse(_scheduledDate.year.toString() +
       //   _scheduledDate.month.toString() +
       //   _scheduledDate.day.toString());
      var todaysDate = ToDoItem.toSortableDate(DateTime.now());

      if (scheduledDate < todaysDate) {
        return true;
      } else {
        return false;
      }
    }
  }

  int get daysOverdue {
    DateTime now = DateTime.now();
    DateTime then = ToDoItem.toDateTime(scheduledDate);

    // var then = DateTime()
    var diff = now.difference(then);

    return diff.inDays;
  }

  String get dateFormattedStr {
    DateFormat formatter = new DateFormat('d MMM');
    DateTime date = ToDoItem.toDateTime(scheduledDate);
    String formatted = formatter.format(date);
    return formatted;
  }

  Map<String, dynamic> toJsonEncodable() {
    Map<String, dynamic> m = new Map();

    m['title'] = title;
    m['isComplete'] = isComplete;
    m['isToday'] = isToday;
    m['scheduledDate'] = scheduledDate;

    return m;
  }

  static int toSortableDate(DateTime date) {
    DateFormat formatter = new DateFormat('yyyyMMdd');
    String sortableStr = formatter.format(date);
    //String sortableStr = date.year.toString() + date.month.toString() + date.day.toString();
    int sortableInt = int.parse(sortableStr);
    return sortableInt;
  }

  static DateTime toDateTime(int sortableDate) {
    String strDate = sortableDate.toString();
    int year = int.parse(strDate.substring(0,4));
    int month = int.parse(strDate.substring(4,6));
    int day = int.parse(strDate.substring(6,8));
    return DateTime(year, month, day);
  }
  // static DateTime toSortableDate(DateTime date) {
  //   DateTime sortable = DateTime(date.year, date.month, date.day);
  //   // int sortable = int.parse(date.year.toString() +
  //   //       date.month.toString() +
  //   //       date.day.toString());
  //   return sortable;
  // }

  void update(String newTitle, int newScheduledDate) {
    title = newTitle;
    scheduledDate = newScheduledDate;
  }

  void markCompleted() {
    print("marking $title as completed");
    isComplete = true;
    isToday = false;
    scheduledDate = 0;
    //key = UniqueKey(); ???
  }

  void markToday() {
    print("marking $title as today");
    isToday = true;
    key = UniqueKey();
  }

  void markScheduled(int newScheduledDate) {
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
