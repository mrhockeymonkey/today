import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_item.dart';
import './settings_page.dart';
// import 'package:today/models/todo_category.dart';
// import 'package:today/models/todo_item.dart';
// import 'package:today/pages/item_page.dart';

class LaterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LaterPageState();
  }
}

class _LaterPageState extends State<LaterPage> {
  Color headerColor = AppConstants.laterHeaderColor;

  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(AppConstants.laterColor);

    print("Build: later page");
    return Scaffold(
        appBar: AppBar(
          title: Text("5 Things"),
          backgroundColor: headerColor,
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPage()),
                );
              },
            )
          ],
        ),
        body: _buildBody()
        //floatingActionButton: _buildFloatingActionButton(),
        );
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FutureBuilder(
          future: appState.storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<ToDoItem> items;

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[
                  CategoryHeader(
                    headerColor: headerColor,
                    headerCount: 0,
                  ),
                  CircularProgressIndicator()
                ],
              );
            }

            appState.initialize();
            items = appState.allScheduledItems;

            return CustomScrollView(slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    CategoryHeader(
                      headerColor: headerColor,
                      headerCount: items.length,
                    ),
                  ],
                ),
              ),
              ToDoList(
                items: items,
                pageType: PageType.later,
              ),
            ]);
            // return Column(
            //   children: <Widget>[
            //     CategoryHeader(
            //       headerColor: headerColor,
            //       headerCount: items.length,
            //     ),
            //     ToDoList(
            //       items: items,
            //       pageType: PageType.later,
            //     ),
            //   ],
            // );
          },
        );
      },
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     padding: EdgeInsets.all(10.0),
  //     //color: widget.category.color,
  //     child: Row(
  //       children: <Widget>[
  //         Expanded(
  //           child: Text('Keep it up'),
  //         ),
  //         CircleAvatar(
  //           //child: Text(widget.category.leftToDoCount.toString()),
  //           child: Text("?"),
  //           radius: 28, //sized to match floating action button
  //           backgroundColor: Colors.white,
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
