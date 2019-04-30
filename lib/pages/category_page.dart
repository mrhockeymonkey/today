import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/todo_category.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/pages/item_page.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  CategoryPage(this.category);

  @override
  State<StatefulWidget> createState() {
    return _CategoryState();
  }
}

class _CategoryState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    AppConstants.changeStatusColor(widget.category.color);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: widget.category.color,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          CategoryHeader(
            headerColor: widget.category.color,
            headerCount: widget.category.leftToDoCount,
          ),
          widget.category.items.length == 0
              ? Text("ddddddddddddddd")
              : ToDoList(
                items: widget.category.itemsSorted,
              ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  // Widget _buildTodoList() {
  //   List<ToDoItem> items = widget.category.itemsSorted();

  //   return Expanded(
  //     child: ListView.builder(
  //       itemCount: items.length,
  //       itemBuilder: (BuildContext context, int index) {
  //         ToDoItem item = items[index];
  //         Future<bool> _confirmDissmiss(DismissDirection direction) async {
  //           if (direction == DismissDirection.startToEnd) {
  //             print('>');
  //             item.isComplete = true;
  //             setState(() {});
  //           } else {
  //             print('<');
  //             item.isToday = true;
  //             setState(() {});
  //           }
  //           return false;
  //         }

  //         return Dismissible(
  //           key: item.key,
  //           direction: DismissDirection.horizontal,
  //           confirmDismiss: _confirmDissmiss,
  //           onDismissed: (DismissDirection direction) {},
  //           background: Container(
  //             padding: EdgeInsetsDirectional.only(start: 15.0),
  //             alignment: Alignment.centerLeft,
  //             color: AppConstants.completeColor,
  //             child: Row(
  //               children: <Widget>[
  //                 Icon(
  //                   Icons.done,
  //                   color: Colors.white,
  //                 ),
  //                 Text('COMPLETE')
  //               ],
  //             ),
  //           ),
  //           secondaryBackground: Container(
  //             padding: EdgeInsetsDirectional.only(end: 15.0),
  //             alignment: Alignment.centerRight,
  //             color: Color(0xFF6A88BA),
  //             child: Row(
  //               children: <Widget>[
  //                 Expanded(
  //                   child: Container(),
  //                 ),
  //                 Icon(
  //                   Icons.add,
  //                   color: Colors.white,
  //                 ),
  //                 Text('TODAY')
  //               ],
  //             ),
  //           ),
  //           child: Column(
  //             children: <Widget>[
  //               _buildListTile(item),

  //               ///Divider(),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  // Widget _buildListTile(ToDoItem item) {
  //   if (item.isComplete) {
  //     return Ink(
  //       color: Theme.of(context).disabledColor,
  //       child: ListTile(
  //         title: Text(
  //           item.title,
  //           style: TextStyle(decoration: TextDecoration.lineThrough),
  //         ),
  //         trailing: Text('complete'),
  //       ),
  //     );
  //   } else if (item.isToday) {
  //     return ListTile(
  //       title: Text(item.title),
  //       trailing: Text('today'),
  //     );
  //   } else {
  //     return ListTile(
  //       title: Text(item.title),
  //     );
  //   }
  // }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: widget.category.color,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ItemPage(widget.category)),
        );
      },
    );
  }
}
