import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../pages/item_page.dart';
import '../models/app_state.dart';

class NewItemFab extends StatelessWidget {
  final bool initIsToday;
  final Color color;

  NewItemFab({
    @required this.initIsToday,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    AppState appState = ScopedModel.of<AppState>(context);

    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: color,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ItemPage(
                    categoryIndex: appState.defaultCategoryIndex,
                    focusKeyboard: true,
                  )),
        );
      },
    );
  }
}
