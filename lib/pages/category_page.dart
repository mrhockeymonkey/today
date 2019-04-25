import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';
import 'package:today/models/todo_category.dart';
import 'package:today/models/todo_item.dart';

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
          _buildHeader(),
          _buildTodoList(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: widget.category.color,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('Keep it up'),
          ),
          CircleAvatar(
            child: Text(widget.category.items.length.toString()),
            radius: 28, //sized to match floating action button
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    List<ToDoItem> items = widget.category.items;
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: items[index].key,
            direction: DismissDirection.startToEnd,
            onDismissed: (DismissDirection direction) {
              setState(() {
                widget.category.removeItem(items[index]);
              });
            },
            background: Container(
              padding: EdgeInsetsDirectional.only(start: 15.0),
              alignment: Alignment.centerLeft,
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(items[index].title),
                ),
                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: widget.category.color,
      onPressed: () {
        setState(() {
          widget.category.addItem(
            ToDoItem(title: '????')
          );
        });
      },
    );
  }
}
