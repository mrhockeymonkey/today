import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';

class ItemPage extends StatefulWidget {
  final int categoryIndex;
  final int itemIndex;

  ItemPage({
    @required this.categoryIndex,
    this.itemIndex,
  });

  @override
  State<StatefulWidget> createState() {
    return _ItemPageState();
  }
}

class _ItemPageState extends State<ItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isNewItem = true;
  Map<String, dynamic> _formData;
  int _itemIndex;
  int _categoryIndex;
  Color _categoryColor;

  @override
  void initState() {
    super.initState();

    _categoryIndex = widget.categoryIndex;
    var appState = ScopedModel.of<AppState>(context);
    var category = appState.categories[_categoryIndex];
    _categoryColor = category.color;

    if (widget.itemIndex != null) {
      var _item = category.items[widget.itemIndex];
      _itemIndex = widget.itemIndex;
      _isNewItem = false;

      _formData = {
        "itemTitle": _item.title,
        "itemScheduledDate": _item.scheduledDate,
      };
    } else {
      _formData = {
        "itemTitle": null,
        "itemScheduledDate": null,
      };
    }
  }

  //---------- build method
  @override
  Widget build(BuildContext context) {
    print("BUILD - item_page");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _categoryColor,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          _buildInputHeader(),
          _buildListView(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  //---------- datepicker popup
  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(Duration(days: 365)),
        lastDate: DateTime.now().add(Duration(days: 365 * 2)));
    if (picked != null) setState(() => _formData['itemScheduledDate'] = picked);
  }

  //---------- input header
  Widget _buildInputHeader() {
    // category =
    //     ScopedModel.of<AppState>(context).categories[widget.categoryIndex];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      color: _categoryColor, //category.color,
      child: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Title',
          ),
          initialValue: _formData['itemTitle'],
          autofocus: true,
          onSaved: (String value) {
            _formData['itemTitle'] = value;
          },
        ),
      ),
    );
  }

  //---------- item options (main body)
  Widget _buildListView() {
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.category),
          title: Text('Category'),
          subtitle: Text("Organize items into categories"),
        ),
        ListTile(
          leading: Icon(Icons.done),
          title: Text('Today'),
          subtitle: Text("Mark item as due today"),
        ),
        ListTile(
          leading: Icon(Icons.today),
          title: Text('Schedule'),
          subtitle: Text("Mark item as due for a later date"),
          onTap: _selectDate,
        ),
      ],
    );
  }

  //---------- floating action button
  Widget _buildFloatingActionButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget widget, AppState appState) {
        return FloatingActionButton(
          child: Icon(Icons.done),
          backgroundColor: _categoryColor,
          onPressed: () {
            if (!_formKey.currentState.validate()) {
              return;
            }
            _formKey.currentState.save();

            if (_isNewItem) {
              ToDoItem _newItem = ToDoItem(title: _formData['itemTitle']);
              if (_formData['itemScheduledDate'] != null) {
                _newItem.scheduledDate = _formData['itemScheduledDate'];
              }
              appState.addItemToCategory(_categoryIndex, _newItem);
            } else {
              appState.updateItemInCategory(
                categoryIndex: _categoryIndex,
                itemIndex: _itemIndex,
                newTitle: _formData['itemTitle'],
                newScheduledDate: _formData['itemScheduledDate'],
              );
            }
            Navigator.pop(context);
          },
        );
      },
    );

    // Category category =
    //     ScopedModel.of<AppState>(context).categories[widget.categoryIndex];
  }
}
