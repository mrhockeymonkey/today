import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ToDoItem {
  String title;
  int id;
  UniqueKey key = UniqueKey();
  bool isComplete = false;
  int scheduledDate = 0;
  int completedDate = 0;
  int repeatNum = 0;
  String repeatLen = 'days';
  int seriesLen = 0;
  int seriesProgress = 0;

  ToDoItem({
    @required this.title,
  }) {
    this.id = UniqueKey().hashCode;
  }

  ToDoItem.custom({
    @required this.title,
    this.scheduledDate,
  }) {
    this.id = UniqueKey().hashCode;
  }

  ToDoItem.fromStorage({
    @required this.id,
    @required this.title,
    @required this.isComplete,
    @required this.scheduledDate,
    @required this.completedDate,
    @required this.repeatNum,
    @required this.repeatLen,
    @required this.seriesLen,
    @required this.seriesProgress,
  });

  //--------- helper methods for conditionals
  bool get isScheduled {
    // if the scheduledDate value is anything but 0 consider it to be scheduled
    if (scheduledDate > 0 && !isComplete) {
      return true;
    } else {
      return false;
    }
  }

  bool get isRecurring {
    if (repeatNum > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool get isSeries {
    if (seriesLen > 0) {
      return true;
    } else {
      return false;
    }
  }

  bool get isDue {
    // if the scheduledDate is in the past then consider it to be due
    var todaysDate = ToDoItem.toSortableDate(DateTime.now());

    if (scheduledDate <= todaysDate && scheduledDate > 0) {
      return true;
    } else {
      return false;
    }
  }

  int get daysOverdue {
    DateTime now = DateTime.now();
    DateTime then = ToDoItem.toDateTime(scheduledDate);

    var diff = now.difference(then);

    return diff.inDays;
  }

  String get scheduledDateFormattedStr {
    DateFormat formatter = new DateFormat('d MMM');
    DateTime date = ToDoItem.toDateTime(scheduledDate);
    String formatted = formatter.format(date);
    return formatted;
  }

  String get completedDateFormattedStr {
    try {
      DateFormat formatter = new DateFormat('d MMM');
      DateTime date = ToDoItem.toDateTime(completedDate);
      String formatted = formatter.format(date);
      return formatted;
    } on Error catch (e) {
      print(e);
      return "";
    }
  }

  Map<String, dynamic> toJsonEncodable() {
    Map<String, dynamic> m = new Map();

    m['id'] = id;
    m['title'] = title;
    m['isComplete'] = isComplete;
    m['scheduledDate'] = scheduledDate;
    m['completedDate'] = completedDate;
    m['repeatNum'] = repeatNum;
    m['repeatLen'] = repeatLen;
    m['seriesLen'] = seriesLen;
    m['seriesProgress'] = seriesProgress;

    return m;
  }

  static int toSortableDate(DateTime date) {
    DateFormat formatter = new DateFormat('yyyyMMdd');
    String sortableStr = formatter.format(date);
    int sortableInt = int.parse(sortableStr);
    return sortableInt;
  }

  static DateTime toDateTime(int sortableDate) {
    String strDate = sortableDate.toString();
    int year = int.parse(strDate.substring(0, 4));
    int month = int.parse(strDate.substring(4, 6));
    int day = int.parse(strDate.substring(6, 8));
    return DateTime(year, month, day);
  }

  void update(String newTitle, int newScheduledDate) {
    title = newTitle;
    scheduledDate = newScheduledDate;
  }

  void markCompleted() {
    print("marking $title as completed");
    isComplete = true;
    completedDate = ToDoItem.toSortableDate(DateTime.now());
    scheduledDate = 0;
  }

  void markToday() {
    print("marking $title as today");
    scheduledDate = 0;
    key = UniqueKey();
  }

  void markScheduled(int newScheduledDate) {
    print("marking $title as scheduled");
    scheduledDate = newScheduledDate;
    key = UniqueKey();
  }

  void markUncompleted() {
    print("marking $title as uncompleted");
    isComplete = false;
    key = UniqueKey();
  }
}
