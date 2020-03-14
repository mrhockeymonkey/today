import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:localstorage/localstorage.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo_item.dart';
import '../models/app_constants.dart';
import './category.dart';
import 'package:jiffy/jiffy.dart';

class AppState extends Model {
  // for now we just declare categories here until we can save data to phone
  List<Category> _categories = [];


  final LocalStorage storage = new LocalStorage('today_app');
  //final LocalStorage settings = new LocalStorage('today_settings');

  // getter for categories
  List<Category> get categories {
    return List.from(_categories);
  }

  // getter for all items across all categories
  List<ToDoItem> get allToDoItems {
    List<ToDoItem> _items = [];
    for (var c in _categories) {
      _items.addAll(c.itemsToDo);
    }
    return _items;
  }

  // getter for all today's items across all categories
  List<ToDoItem> get allTodayItems {
    List<ToDoItem> _todayItems = [];
    for (var c in _categories) {
      _todayItems.addAll(c.itemsTodayAndDue);
    }
    //_todayItems.sort((a, b) => a.isComplete.toString().compareTo(b.isComplete.toString()));
    return _todayItems;
  }

  int get todayItemCount {
    List<ToDoItem> items = allTodayItems;
    return items.length;
  }

  bool get isTodayFull {
    return todayItemCount >= 5;
  }

  // getter for all completed items across all categories
  List<ToDoItem> get allCompletedItems {
    List<ToDoItem> _completedItems = [];
    for (var c in _categories) {
      _completedItems.addAll(c.itemsCompleted);
    }
    return _completedItems;
  }

  // getter for all items completed today
  List<ToDoItem> get allCompletedTodayItems {
    List<ToDoItem> _completedItems = [];
    for (var c in _categories) {
      _completedItems.addAll(c.itemsCompletedToday);
    }
    return _completedItems;
  }

  // getter for all scheduled items across all categories
  List<ToDoItem> get allScheduledItems {
    List<ToDoItem> _scheduledItems = [];
    for (var c in _categories) {
      _scheduledItems.addAll(c.itemsScheduled);
    }
    _scheduledItems.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
    return _scheduledItems;
  }

  // clear all today items
  // void clearTodayItems() {
  //   for (var c in _categories) {
  //     c.itemsToday.forEach((i) => i.isToday = false);
  //   }
  //   saveToStorage();
  // }

  //
  int categoryIndexOf(ToDoItem item) {
    int index;
    for (var c in _categories) {
      index = _categories.indexOf(c);
      if (c.items.indexOf(item) >= 0) {
        break;
      }
    }
    return index;
  }

  //
  void addItemToCategory(int index, ToDoItem newItem) {
    _categories[index].addItem(newItem);
    saveToStorage();
  }

  // update and item in a category
  void updateItemInCategory({
    @required int categoryIndex,
    @required int itemIndex,
    String newTitle,
    bool newIsToday,
    int newScheduledDate,
    int newRepeatNum,
    String newRepeatLen,
    int newSeriesLen,
  }) {
    _categories[categoryIndex].updateItem(
      itemIndex,
      newTitle,
      newIsToday,
      newScheduledDate,
      newRepeatNum,
      newRepeatLen,
      newSeriesLen,
    );
    saveToStorage();
  }

  void updateCategoryName({
    @required int categoryIndex,
    @required String newName,
  }) {
    _categories[categoryIndex].name = newName;
    saveToStorage();
  }

  // update an item and moves it to a new category
  void updateItemMoveCategory({
    @required int originalCategoryIndex,
    @required int newCategoryIndex,
    @required int itemIndex,
    String newTitle,
    bool newIsToday,
    int newScheduledDate,
    int newRepeatNum,
    String newRepeatLen,
    int newSeriesLen,
  }) {
    var originalCategory = _categories[originalCategoryIndex];
    var newCategory = _categories[newCategoryIndex];
    var item = originalCategory.items[itemIndex];
    originalCategory.removeItem(item);
    newCategory.addItem(item);
    var newIndex = newCategory.items.indexOf(item);
    newCategory.updateItem(
      newIndex,
      newTitle,
      newIsToday,
      newScheduledDate,
      newRepeatNum,
      newRepeatLen,
      newSeriesLen,
    );

    saveToStorage();
  }

  // delete all items
  void deleteCompletedItems() {
    for (var c in _categories) {
      c.itemsCompleted.forEach((i) => c.removeItem(i));
    }
    saveToStorage();
  }

  String getJson() {
    List jsonEncoded = [];
    String jsonString = "";
    _categories.forEach((i) {
      jsonEncoded.add(i.toJsonEncodable());
    });

    jsonEncoded.forEach((i) {
      jsonString = jsonString + i.toString();
    });

    return jsonString;
  }

  void saveToStorage() {
    List jsonEncoded = [];
    _categories.forEach((i) {
      jsonEncoded.add(i.toJsonEncodable());
    });

    storage.setItem('appdata', jsonEncoded);
    notifyListeners();
    print("saved to local storage, notified listerners");
  }

  /// reads from local storage or creates some default appdata if not found
  void initialize() async {
    List appData = storage.getItem('appdata');

    if (appData == null || appData.isEmpty) {
      print("AppState.initialize: No app data found, initializing defaults");
      Jiffy now = Jiffy();
      DateTime tomorrow = now.add(days: 1);
      int intTomorrow = ToDoItem.toSortableDate(tomorrow);

      _categories
        ..add(Category(name: "MUST DO", color: AppConstants.categoryColors[0]))
        ..add(Category(name: "WANT TO", color: AppConstants.categoryColors[1]))
        ..add(Category(name: "SHOULD DO", color: AppConstants.categoryColors[2]))
        ..add(Category(name: "COULD DO", color: AppConstants.categoryColors[3]))
        ..add(Category(name: "FYI", color: AppConstants.categoryColors[4]));
      _categories[0]
        ..addItem(ToDoItem.custom(title: 'Focus On Up To Five Tasks Each Day', isToday: true));
      _categories[1]
        ..addItem(ToDoItem.custom(title: 'Swipe Right To Complete', isToday: true));
      _categories[2]
        ..addItem(ToDoItem.custom(title: 'Swipe Left To Snooze Until Tomorrow', isToday: true))
        ..addItem(ToDoItem.custom(title: 'Tap For Menu', isToday: true));
      _categories[3]
        ..addItem(ToDoItem.custom(title: 'These Are Tasks You Are Not Focused On', isToday: false))
        ..addItem(ToDoItem.custom(title: 'Add New Tasks By Taping ( + )', isToday: false));
      _categories[4]
        ..addItem(ToDoItem.custom(title: 'Scheduled Tasks Appear Here', isToday: false, scheduledDate: intTomorrow))
        ..addItem(ToDoItem.custom(title: 'Tasks Become Focused When Due', isToday: false, scheduledDate: intTomorrow));

      saveToStorage();
    } else {
      print("AppState.initialize: App data found, loading from local storage");
      _categories.clear();
      appData.forEach((i) {
        Category c = Category(name: i['name'], color: Color(i['color']));
        List l = i['items'];
        l.forEach((j) {
          c.addItem(
            ToDoItem.fromStorage(
              title: j['title'],
              isComplete: j['isComplete'],
              isToday: j['isToday'],
              scheduledDate: j['scheduledDate'] ?? 0,
              completedDate: j['completedDate'] ?? 0,
              repeatNum: j['repeatNum'] ?? 0,
              repeatLen: j['repeatLen'] ?? 'days',
              seriesLen: j['seriesLen'] ?? 0,
            ),
          );
        });
        _categories.add(c);
      });
    }
  }
}
