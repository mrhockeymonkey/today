import 'package:flutter/material.dart';

import 'package:today/pages/item_page.dart';

class NewItemFab extends StatelessWidget {
  final int defaultCategoryIndex = 2;
  bool initIsToday;
  Color color;

  NewItemFab({
    @required this.initIsToday,
    @required this.color
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: color,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemPage(
                    categoryIndex: defaultCategoryIndex,
                    initIsToday: initIsToday
                  )),
        );
      },
    );
  }
}
