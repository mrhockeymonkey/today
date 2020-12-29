import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:today/pages/goals_select_page.dart';
import 'package:today/widgets/tdl_base.dart';
import '../models/todo_item.dart';
import '../models/app_state.dart';
import '../models/app_constants.dart';

class HighlightedToday extends StatefulWidget {
  final bool isEditing;
  final Map<int, ToDoItem> goals;

  HighlightedToday({
    @required this.isEditing,
    @required this.goals,
  });

  @override
  State<StatefulWidget> createState() {
    return _HighlightedToday();
  }
}

class _HighlightedToday extends State<HighlightedToday> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        //itemExtent: 72.0,
        delegate: SliverChildBuilderDelegate(
      (BuildContext context, int index) => _buildListTile(context, index),
      childCount: 5,
    ));
  }

// fuck this. make it a separate page FML
  Widget _buildListTile(BuildContext context, int index) {
    AppState appState = ScopedModel.of<AppState>(context);
    ToDoItem item = appState.getGoalItem(index);

    if (widget.isEditing) {
      return ListTile(
        title: Text("goal #" + index.toString()),
        onTap: () {},
      );
    } else {
      return item == null
          ? null
          : ListTile(
              title: Text("item"),
            );
    }
  }

  // List<Widget> _buildList() {
  //   int itemsLength = widget.items.length;
  //   // AppState appState = ScopedModel.of<AppState>(context);
  //   // List<Widget> goalTiles = new List<Widget>();
  //   // int categoryIndex;
  //   // int goalItemIndex = 0;

  //   //return List<>

  //   return List<Widget>.generate(5, (index) {
  //     ToDoItem item = ScopedModel.of<AppState>(context).getGoalItem(index);
  //     if (item != null) {
  //       return ListTile(
  //         title: Text(item.title),
  //         subtitle: Text("sub"),
  //         onTap: () => pushItemSelectPage(context, index),
  //       );
  //     } else {
  //       return ListTile(
  //         title: Text("Goal #" + index.toString()),
  //         subtitle: Text("Goal #" + (index + 1).toString()),
  //         // leading: Icon(
  //         //   AppConstants.categoryIcons[0],
  //         // ),
  //         trailing: widget.isEditing
  //             ? Icon(Icons.swap_horiz)
  //             : Icon(Icons.ac_unit_rounded),
  //         onTap: () => pushItemSelectPage(context, index),
  //       );
  //     }
  //   });

  // widget.items.forEach((item) {
  //   categoryIndex = appState.categoryIndexOf(item);
  //   goalItemIndex = widget.items.indexOf(item);

  //   goalTiles.add(
  //     ListTile(
  //       title: Text(item.title),
  //       subtitle: Text("Goal #" + (goalItemIndex + 1).toString()),
  //       leading: Icon(
  //         AppConstants.categoryIcons[categoryIndex],
  //       ),
  //       onTap: () => {print(item.title)},
  //     ),
  //   );

  //   goalItemIndex++;
  // });

  // for (var i = 0; i < 5; i++) {
  //   goalTiles.add(ListTile(
  //     title: Text("foo"),
  //     leading: Icon(
  //       Icons.add_circle,
  //       color: Colors.grey,
  //     ),
  //     subtitle: Text("subtitle"),
  //     onTap: () => {},
  //   ));
  // }
  //return goalTiles;
  // }

}
