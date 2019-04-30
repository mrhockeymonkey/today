import 'package:flutter/material.dart';

import 'package:today/models/todo_category.dart';
import 'package:today/models/todo_item.dart';

class ItemPage extends StatefulWidget {
  final Category category;

  ItemPage(this.category);

  @override
  State<StatefulWidget> createState() {
    return _ItemPageState();
  }
}

class _ItemPageState extends State<ItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _formData = {"itemTitle": null};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.category.color,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          _buildInputHeader(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildInputHeader() {
    return Container(
        padding: EdgeInsets.all(10.0),
        color: widget.category.color,
        child: Form(
          key: _formKey,
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
            autofocus: true,
            onSaved: (String value) {
              _formData['itemTitle'] = value;
            },
          ),
        ));
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.done),
      backgroundColor: widget.category.color,
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();
        ToDoItem _newItem = ToDoItem(title: _formData['itemTitle']);
        widget.category.addItem(_newItem);
        Navigator.pop(context);
      },
    );
  }
}
