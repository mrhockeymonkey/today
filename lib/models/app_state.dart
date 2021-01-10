import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:jiffy/jiffy.dart';

import '../models/todo_item.dart';
import '../models/app_constants.dart';
import './category.dart';

class AppState extends Model {
  // for now we just declare categories here until we can save data to phone
  List<Category> _categories = [];
  Map<int, ToDoItem> _goals = {};
  int _defaultCategoryIndex;

  final LocalStorage storage = new LocalStorage('today_app');

  // getter for categories
  List<Category> get categories {
    return List.from(_categories);
  }

  int get defaultCategoryIndex {
    return _defaultCategoryIndex;
  }

  void setDefaultCategory(int categoryIndex) {
    _defaultCategoryIndex = categoryIndex;
    saveToStorage();
  }

  // getter for all items across all categories
  List<ToDoItem> get allItems {
    List<ToDoItem> _items = [];
    for (var c in _categories) {
      _items.addAll(c.items);
    }
    return _items;
  }

  //
  List<ToDoItem> get allToDoItems {
    List<ToDoItem> _items = [];
    for (var c in _categories) {
      _items.addAll(c.itemsToDo);
    }
    return _items;
  }

  //
  List<ToDoItem> get allToDoItemsExcludingGoals {
    List<ToDoItem> _items = allToDoItems;
    _goals.entries.forEach((element) {
      _items.remove(element.value);
    });
    return _items;
  }

  //
  List<ToDoItem> get allDueItems {
    List<ToDoItem> _items = [];
    for (var c in _categories) {
      _items.addAll(c.itemsScheduledNowDue);
    }
    return _items;
  }

  //
  List<ToDoItem> get allDueItemsExcludingGoals {
    List<ToDoItem> _items = allDueItems;
    _goals.entries.forEach((element) {
      _items.remove(element.value);
    });
    return _items;
  }

  //
  List<ToDoItem> get allToDoAndDueItemsExcludingGoals {
    List<ToDoItem> _items = [];
    for (var c in _categories) {
      _items.addAll(c.itemsScheduledNowDue);
    }
    for (var c in _categories) {
      _items.addAll(c.itemsToDo);
    }
    _goals.entries.forEach((element) {
      _items.remove(element.value);
    });
    return _items;
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

  //
  Map<int, ToDoItem> get goals {
    return _goals;
  }

  //
  ToDoItem getGoalItem(int goalIndex) {
    if (_goals.containsKey(goalIndex)) {
      return _goals[goalIndex];
    } else {
      return null;
    }
  }

  //
  void setGoalItem(int goalIndex, ToDoItem goalItem) {
    _goals.removeWhere((key, value) => value.id == goalItem.id);
    _goals[goalIndex] = goalItem;
    print("set goal #$goalIndex: ${goalItem.title}");
    saveToStorage();
  }

  //
  void removeGoalItem(int goalIndex) {
    _goals.remove(goalIndex);
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
    @required String newIconName,
  }) {
    _categories[categoryIndex].name = newName;
    _categories[categoryIndex].iconName = newIconName;
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
    Map<String, dynamic> appData = {
      "version": 2,
      "goals": {},
      "categories": [],
      "default_category": _defaultCategoryIndex
    };

    Map<String, dynamic> jsonEncodedGoals = {};
    _goals.forEach((key, value) {
      jsonEncodedGoals[key.toString()] = value.id;
    });
    appData["goals"] = jsonEncodedGoals;

    _categories.forEach((item) {
      appData["categories"].add(item.toJsonEncodable());
    });

    storage.setItem('data', appData);
    notifyListeners();
    print("saved to local storage, notified listerners");
  }

  /// reads from local storage or creates some default appdata if not found
  void initialize() async {
    Map<String, dynamic> appData = storage.getItem('data');

    if (appData == null || appData.isEmpty) {
      print("AppState.initialize: No app data found, initializing defaults");
      Jiffy now = Jiffy();
      DateTime tomorrow = now.add(days: 1);
      int intTomorrow = ToDoItem.toSortableDate(tomorrow);

      _categories
        ..add(Category(
            name: "MUST DO",
            color: AppConstants.categoryColors[0],
            iconName: "flag"))
        ..add(Category(
            name: "WANT TO",
            color: AppConstants.categoryColors[1],
            iconName: "game_controller"))
        ..add(Category(
            name: "SHOULD DO",
            color: AppConstants.categoryColors[2],
            iconName: "pin"))
        ..add(Category(
            name: "COULD DO",
            color: AppConstants.categoryColors[3],
            iconName: "pin"))
        ..add(Category(
            name: "FYI",
            color: AppConstants.categoryColors[4],
            iconName: "pin"));
      _categories[0]
        ..addItem(ToDoItem.custom(title: 'Up To 5 Items Can Be Displayed Here'))
        ..addItem(ToDoItem(title: 'These Are The Rest Of Your Todo Items'));
      _categories[1]
        ..addItem(ToDoItem.custom(title: 'Swipe Right To Complete'));
      _categories[2]
        ..addItem(ToDoItem(title: 'Scroll Down To See Your Other Items'))
        ..addItem(ToDoItem.custom(title: 'Swipe Left To Snooze Until Tomorrow'))
        ..addItem(ToDoItem.custom(title: 'Tap To Edit Item'));
      _categories[3]
        ..addItem(ToDoItem.custom(title: 'Add New Tasks By Taping ( + )'));
      _categories[4]
        ..addItem(ToDoItem.custom(
            title: 'Scheduled Tasks Appear Here', scheduledDate: intTomorrow))
        ..addItem(ToDoItem.custom(
            title: 'Scheduled Tasks Move Back To Your List When Due',
            scheduledDate: intTomorrow));

      _goals[0] = _categories[0].items[0];
      _goals[1] = _categories[1].items[0];
      _goals[2] = _categories[2].items[0];

      _defaultCategoryIndex = 2;

      saveToStorage();
    } else {
      print("AppState.initialize: App data found, loading from local storage");
      _categories.clear();

      _defaultCategoryIndex = appData['default_category'] ?? 2;

      // loads items into categories
      appData["categories"].forEach((i) {
        Category c = Category(
          name: i['name'],
          color: Color(i['color']),
          iconName: i['iconName'] ?? "pin",
        );
        List l = i['items'];
        l.forEach((j) {
          ToDoItem item = ToDoItem.fromStorage(
            id: j['id'],
            title: j['title'],
            isComplete: j['isComplete'],
            scheduledDate: j['scheduledDate'] ?? 0,
            completedDate: j['completedDate'] ?? 0,
            repeatNum: j['repeatNum'] ?? 0,
            repeatLen: j['repeatLen'] ?? 'days',
            seriesLen: j['seriesLen'] ?? 0,
            seriesProgress: j['seriesProgress'] ?? 0,
          );
          c.addItem(item);
        });
        _categories.add(c);
      });

      // load goals
      List<ToDoItem> all = allItems;
      if (appData["goals"] != null) {
        appData["goals"].forEach((key, value) {
          print(key.toString() + "-" + value.toString());
          int goalIndex = int.parse(key);
          ToDoItem goalItem = all.firstWhere((element) => element.id == value);
          _goals[goalIndex] = goalItem;
        });
      }
    }
  }
}
