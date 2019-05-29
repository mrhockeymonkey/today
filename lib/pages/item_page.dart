import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/todo_category.dart';

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
  String _categoryTitle;
  Color _categoryColor;

  @override
  void initState() {
    super.initState();

    _categoryIndex = widget.categoryIndex;
    var appState = ScopedModel.of<AppState>(context);
    var category = appState.categories[_categoryIndex];
    _categoryColor = category.color;
    _categoryTitle = category.name;

    if (widget.itemIndex != null) {
      var _item = category.items[widget.itemIndex];
      _itemIndex = widget.itemIndex;
      _isNewItem = false;

      _formData = {
        "itemTitle": _item.title,
        "itemScheduledDate": _item.scheduledDate,
        "itemIsToday": _item.isToday,
      };
    } else {
      _formData = {
        "itemTitle": null,
        "itemScheduledDate": null,
        "itemIsToday": false,
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
        title: Text(_categoryTitle),
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

  //---------- today picker
  void _selectToday() {
    setState(() {
      _formData['itemIsToday'] = ! _formData['itemIsToday'];
    });
  }

  //---------- category picker popup
  Future _selectCategory() async {
    AppState appState = ScopedModel.of<AppState>(context);
    List<Category> categories = appState.categories;
    int picked;

    picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          //title: const Text('Select category'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Text(categories[0].name),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Text(categories[1].name),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 2);
              },
              child: Text(categories[2].name),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 3);
              },
              child: Text(categories[3].name),
            ),
          ],
        );
      },
    );

    print(picked);
    if (picked != null)
      setState(() {
        _categoryIndex = picked;
        _categoryTitle = categories[picked].name;
        _categoryColor = categories[picked].color;
      });
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
          onTap: _selectCategory,
        ),
        ListTile(
          leading: _formData['itemIsToday']
              ? Icon(
                  Icons.done,
                  color: Colors.green,
                )
              : Icon(
                  Icons.done,
                  color: Colors.grey,
                ),
          title: Text('Today'),
          subtitle: Text("Mark item as due today"),
          onTap: _selectToday,
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
            // validate and save the form data
            if (!_formKey.currentState.validate()) {
              return;
            }
            _formKey.currentState.save();

            // handle and save changes
            if (_isNewItem) {
              ToDoItem _newItem = ToDoItem(title: _formData['itemTitle']);
              if (_formData['itemScheduledDate'] != null) {
                _newItem.scheduledDate = _formData['itemScheduledDate'];
              }
              appState.addItemToCategory(_categoryIndex, _newItem);
            } else {
              //?? if categoryindex has change then delete and re add??
              appState.updateItemInCategory(
                categoryIndex: _categoryIndex,
                itemIndex: _itemIndex,
                newTitle: _formData['itemTitle'],
                newScheduledDate: _formData['itemScheduledDate'],
              );
            }

            // handle if today was selected
            if (_formData['itemIsToday']) {
              print("should be today");
              //appState.categories[_categoryIndex].items[_itemIndex].markToday();
              //appState.saveToStorage();
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
