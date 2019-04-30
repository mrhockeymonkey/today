import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/widgets/category_header.dart';
// import 'package:today/models/todo_category.dart';
// import 'package:today/models/todo_item.dart';
// import 'package:today/pages/item_page.dart';

class LaterPage extends StatefulWidget {
  //final Category category;

  //CategoryPage(this.category);

  @override
  State<StatefulWidget> createState() {
    return _LaterPageState();
  }
}

class _LaterPageState extends State<LaterPage> {
  @override
  Widget build(BuildContext context) {
    AppConstants.changeStatusColor(AppConstants.laterColor);

    return Scaffold(
      appBar: AppBar(
        title: Text("Later"),
        backgroundColor: AppConstants.laterColor,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          CategoryHeader(
            headerColor: AppConstants.laterColor,
            headerCount: 99,
          ),
          // widget.category.items.length == 0
          //     ? Text("Nothing to do")
          //     //: _buildTodoList(),
          //     : Text('implement list'),
        ],
      ),
      //floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(10.0),
      //color: widget.category.color,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('Keep it up'),
          ),
          CircleAvatar(
            //child: Text(widget.category.leftToDoCount.toString()),
            child: Text("?"),
            radius: 28, //sized to match floating action button
            backgroundColor: Colors.white,
          ),
        ],
      ),
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

  // Widget _buildFloatingActionButton() {
  //   return FloatingActionButton(
  //     child: Icon(Icons.add),
  //     backgroundColor: widget.category.color,
  //     onPressed: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => ItemPage(widget.category)),
  //       );
  //     },
  //   );
  // }
}
