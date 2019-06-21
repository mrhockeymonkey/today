import 'package:flutter/material.dart';

import 'package:today/pages/item_page.dart';

class NewItemFab extends StatelessWidget {
  final int defaultCategoryIndex = 2;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.teal,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemPage(
                    categoryIndex: defaultCategoryIndex,
                  )),
        );
      },
    );
  }
}
