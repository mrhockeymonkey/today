import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:localstorage/localstorage.dart';

import 'package:today/models/todo_item.dart';
import './todo_category.dart';

class AppState extends Model {
  // for now we just declare categories here until we can save data to phone
  List<Category> _categories = [];

  // the today category is immutable, core principal of the apps purpose
  //final Category today = Category(name: 'TODAY', color: const Color(0xFF6A88BA));

  final LocalStorage storage = new LocalStorage('today_app');


  // getter for categories
  List<Category> get categories {
    return List.from(_categories);
  }

  // getter for all today's items across all categories
  List<ToDoItem> get allTodayItems {
    List<ToDoItem> _todayItems = [];
    for (var c in _categories) {
      _todayItems.addAll(c.itemsTodayAndDue);
    }
    return _todayItems;
  }

  // getter for all completed items across all categories
  List<ToDoItem> get allCompletedItems {
    List<ToDoItem> _completedItems = [];
    for (var c in _categories) {
      _completedItems.addAll(c.itemsCompleted);
    }
    return _completedItems;
  }

  // getter for all scheduled items across all categories
  List<ToDoItem> get allScheduledItems {
    List<ToDoItem> _scheduledItems = [];
    for (var c in _categories) {
      _scheduledItems.addAll(c.itemsScheduled);
    }
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
  void addItemToCategory(int index, ToDoItem newItem) {
    _categories[index].addItem(newItem);
    saveToStorage();
  }

  // delete all items
  void deleteCompletedItems() {
    for (var c in _categories) {
      c.itemsCompleted.forEach((i) => c.removeItem(i));
    }
    saveToStorage();
  }

  void saveToStorage() {
    List jsonEncoded = [];
    _categories.forEach((i) {
      jsonEncoded.add(i.toJsonEncodable());
    });

    storage.setItem('appdata', jsonEncoded);
    print("saved to local storage");
  }

  /// reads from local storage or creates some default appdata if not found
  void initialize() {
    List appData = storage.getItem('appdata');
    if (appData == null || appData.isEmpty) {
      print("AppState.initialize: No app data found, initializing defaults");
      throw "lost storage???";
      // _categories
      //   ..add(Category(name: 'FOCUS', color: const Color(0xFFEE534F)))
      //   ..add(Category(name: 'GOALS', color: const Color(0xFF00B8D4)))
      //   ..add(Category(name: 'FIT IN', color: const Color(0xFFFBAF28)))
      //   ..add(Category(name: 'BACKBURNER', color: const Color(0xFF01BFA5)));
      // _categories[0]
      //   ..addItem(ToDoItem(title: 'focus1'))
      //   ..addItem(ToDoItem(title: 'focus2'));
      // _categories[1]
      //   ..addItem(ToDoItem(title: 'goals1'))
      //   ..addItem(ToDoItem(title: 'goals2'));
      // _categories[2]
      //   ..addItem(ToDoItem(title: 'fitin1'))
      //   ..addItem(ToDoItem(title: 'fitin2'));
      // _categories[3]
      //   ..addItem(ToDoItem(title: 'back1'))
      //   ..addItem(ToDoItem(title: 'back2'));
      // saveToStorage();
    } else {
      print("AppState.initialize: App data found, loading from local storage");
      _categories.clear();
      appData.forEach((i) {
        Category c = Category(name: i['name'], color: Color(i['color']));
        List l = i['items'];
        l.forEach((j) {
          c.addItem(ToDoItem.fromStorage(
            title: j['title'],
            isComplete: j['isComplete'],
            todayMilliseconds: j['todayMilliseconds'] ?? null,
            scheduledMilliseconds: j['scheduledMilliseconds'] ?? null
          ));
        });
        _categories.add(c);
      });
    }
  }
}
