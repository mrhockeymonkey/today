import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/widgets/category_header.dart';
import 'package:today/widgets/todo_list.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/models/category.dart';
// import 'package:today/models/todo_item.dart';
import 'package:today/pages/item_page.dart';
import 'package:today/widgets/new_item_fab.dart';

class ToDoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ToDoPageState();
  }
}

class _ToDoPageState extends State<ToDoPage> {
  Color todayColor = AppConstants.todayColor;
  
  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(AppConstants.laterColor);

    print("Build: todo page");
    return Scaffold(
        appBar: AppBar(
          title: Text("To Do"),
          backgroundColor: AppConstants.laterColor,
          elevation: 0.0,
        ),
        body: _buildBody(),
        floatingActionButton: NewItemFab(),
        );
  }

  Widget _buildBody() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FutureBuilder(
          future: appState.storage.ready,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<ToDoItem> items;
            // if (snapshot.data == null) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }

            if (snapshot.data == null) {
              return Column(
                children: <Widget>[
                  CategoryHeader(
                    headerColor: todayColor,
                    headerCount: 0,
                  ),
                  CircularProgressIndicator()
                ],
              );
            }

            appState.initialize();
            items = appState.allToDoItems;
            Color completedColor = AppConstants.laterColor;

            return Column(
              children: <Widget>[
                CategoryHeader(
                  headerColor: completedColor,
                  headerCount: items.length,
                ),
                ToDoList(
                  items: items,
                  pageType: PageType.todo,
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Widget _buildFloatingActionButton() {
  //   // Category category =
  //   //     ScopedModel.of<AppState>(context).categories[widget.categoryIndex];

  //   return FloatingActionButton(
  //     child: Icon(Icons.add),
  //     backgroundColor: Colors.indigo,
  //     onPressed: () {
  //       Navigator.of(context, rootNavigator: true).push(
  //         MaterialPageRoute(
  //             builder: (context) => ItemPage(
  //                   categoryIndex: 2, // defaults to fit in?
  //                 )),
  //       );
  //     },
  //   );
  // }
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
