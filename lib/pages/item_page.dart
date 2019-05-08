import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:today/models/todo_category.dart';
import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';

class ItemPage extends StatefulWidget {
  //final Category category;
  final int categoryIndex;

  ItemPage(this.categoryIndex);

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
    Category category =
        ScopedModel.of<AppState>(context).categories[widget.categoryIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: category.color,
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
    Category category =
        ScopedModel.of<AppState>(context).categories[widget.categoryIndex];

    return Container(
      padding: EdgeInsets.all(10.0),
      color: category.color,
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Title'),
          autofocus: true,
          onSaved: (String value) {
            _formData['itemTitle'] = value;
          },
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    Category category =
        ScopedModel.of<AppState>(context).categories[widget.categoryIndex];

    return FloatingActionButton(
      child: Icon(Icons.done),
      backgroundColor: category.color,
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }
        _formKey.currentState.save();
        ToDoItem _newItem = ToDoItem(title: _formData['itemTitle']);
        ScopedModel.of<AppState>(context).addItemToCategory(widget.categoryIndex, _newItem);
        Navigator.pop(context);
      },
    );
  }
}
