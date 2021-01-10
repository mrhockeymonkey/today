import 'package:flutter/material.dart';

import './swipe_background.dart';
import './tdl_tile.dart';
import '../widgets/swipe_background.dart';
import '../widgets/tdl_base.dart';
import '../models/todo_item.dart';
import '../models/app_constants.dart';
import '../models/category.dart';

class TdlDone extends TdlBase {
  final List<ToDoItem> items;
  final PageType pageType;

  TdlDone({
    @required this.items,
    @required this.pageType,
  });

  @override
  State<StatefulWidget> createState() {
    return _TdlPrimary();
  }
}

class _TdlPrimary extends TdlBaseState<TdlDone> {
  @override
  Widget buildListTile(ToDoItem item, Category category, int categoryIndex) {
    return TdlTile(
      item: item,
      category: category,
      categoryIndex: categoryIndex,
    );
  }

  @override
  Widget buildBackground() {
    return SwipeBackground(
      text: "DELETE",
      align: MainAxisAlignment.start,
      icon: Icons.delete,
      bgColor: Colors.red,
      iconColor: Colors.white,
    );
  }

  @override
  Widget buildSecondaryBackground() {
    return SwipeBackground(
      text: "TO DO",
      align: MainAxisAlignment.end,
      icon: Icons.restore,
      bgColor: AppConstants.todoColor,
      iconColor: Colors.white,
    );
  }
}
