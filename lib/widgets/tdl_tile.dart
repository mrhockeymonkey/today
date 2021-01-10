import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../models/app_constants.dart';
import '../models/todo_item.dart';
import '../models/category.dart';

class TdlTile extends StatelessWidget {
  final ToDoItem item;
  final Category category;
  final int categoryIndex;
  final Function onTap;
  final Widget trailing;

  TdlTile({
    @required this.item,
    @required this.category,
    @required this.categoryIndex,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    if (item.isComplete) {
      return _buildCompleteTile();
    }

    if (item.isScheduled) {
      return _buildScheduledTile();
    }

    return _buildRegularTile();
  }

  _buildCompleteTile() {
    return ListTile(
      onTap: onTap,
      title: Text(
        item.title,
        style: TextStyle(decoration: TextDecoration.lineThrough),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            "DONE",
            style: TextStyle(color: category.color),
          ),
          Text(" - "),
          Icon(
            Icons.done,
            color: category.color,
            size: 15,
          ),
          Text(" ${item.completedDateFormattedStr}"),
        ],
      ),
      leading: Icon(
        Icons.done,
        color: category.color,
      ),
      trailing: trailing,
    );
  }

  _buildScheduledTile() {
    return ListTile(
      title: Text(item.title),
      leading: Icon(
        Entypo.hour_glass,
        color: category.color,
      ),
      subtitle: Row(
        children: buildItemSubtitle(item, category),
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }

  _buildRegularTile() {
    return ListTile(
      title: Text(item.title),
      leading: Icon(
        AppConstants.icons[category.iconName],
        color: category.color,
      ),
      subtitle: Row(
        children: buildItemSubtitle(item, category),
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }

  List<Widget> buildItemSubtitle(ToDoItem item, Category category) {
    List<Widget> subtitleElements = [];
    List<Widget> subtitleIndicators = [];

    subtitleElements.add(
      Text(
        "${category.name.toUpperCase()}",
        style: TextStyle(
          color: category.color,
        ),
      ),
    );

    if (item.isScheduled) {
      subtitleIndicators.add(
        Icon(Icons.today, color: category.color, size: 15.0),
      );
      if (item.isScheduled) {
        subtitleIndicators.add(
          Text(" ${item.scheduledDateFormattedStr} "),
        );
      }
    }

    if (item.isRecurring) {
      subtitleIndicators.add(
        Icon(Icons.repeat, color: category.color, size: 15.0),
      );
      subtitleIndicators.add(
        Text(" ${item.repeatNum}${item.repeatLen[0]} "),
      );
    }

    if (item.isSeries) {
      subtitleIndicators.add(
        Icon(Icons.slideshow, color: category.color, size: 15.0),
      );
      subtitleIndicators.add(
        Text(" ${item.seriesProgress}/${item.seriesLen}"),
      );
    }

    // join indicators to subtitle
    if (subtitleIndicators.length > 0) {
      subtitleElements.add(
        Text(" - "),
      );
      subtitleElements.addAll(subtitleIndicators);
    }

    return subtitleElements;
  }
}
