import 'package:flutter/material.dart';

import './swipe_background.dart';
import './tdl_tile.dart';
import '../widgets/tdl_base.dart';
import '../models/todo_item.dart';
import '../models/app_constants.dart';
import '../models/category.dart';

class TdlScheduled extends TdlBase {
  final List<ToDoItem> items;
  final PageType pageType;

  TdlScheduled({
    @required this.items,
    @required this.pageType,
  });

  @override
  State<StatefulWidget> createState() {
    return _TdlPrimary();
  }
}

class _TdlPrimary extends TdlBaseState<TdlScheduled> {
  @override
  Widget buildListTile(ToDoItem item, Category category, int categoryIndex) {
    return TdlTile(
      item: item,
      category: category,
      categoryIndex: categoryIndex,
      onTap: () => pushItemPage(context, item),
    );
  }

  @override
  Widget buildBackground() {
    return SwipeBackground(
      text: "TO DO",
      align: MainAxisAlignment.start,
      icon: Icons.restore,
      bgColor: AppConstants.todoColor,
      iconColor: Colors.white,
    );
  }
}
