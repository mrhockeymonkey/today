import 'package:flutter/material.dart';

import './swipe_background.dart';
import './tdl_tile.dart';
import '../widgets/tdl_base.dart';
import '../models/todo_item.dart';
import '../models/app_constants.dart';
import '../models/category.dart';

class TdlPrimary extends TdlBase {
  final List<ToDoItem> items;
  final PageType pageType;

  TdlPrimary({
    @required this.items,
    @required this.pageType,
  }) : super(items: items, pageType: pageType);

  @override
  State<StatefulWidget> createState() {
    return _TdlPrimary();
  }
}

class _TdlPrimary extends TdlBaseState<TdlPrimary> {
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
      text: "DONE",
      align: MainAxisAlignment.start,
      icon: Icons.done,
      bgColor: AppConstants.completeColor,
      iconColor: Colors.black,
    );
  }

  @override
  Widget buildSecondaryBackground() {
    return SwipeBackground(
      text: "TOMORROW",
      align: MainAxisAlignment.end,
      icon: Icons.today,
      bgColor: AppConstants.laterColor,
      iconColor: Colors.white,
    );
  }
}
