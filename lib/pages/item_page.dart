import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/category.dart';
import 'package:today/models/app_constants.dart';

class ItemPage extends StatefulWidget {
  final int categoryIndex;
  final int itemIndex;
  bool initIsToday;

  ItemPage({
    @required this.categoryIndex,
    this.itemIndex,
    @required this.initIsToday
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
  int _originalCategoryIndex;
  String _categoryTitle;
  Color _categoryColor;

  @override
  void initState() {
    super.initState();

    _categoryIndex = widget.categoryIndex;
    _originalCategoryIndex = widget.categoryIndex;
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
        "itemScheduledDate": 0,
        "itemIsToday": widget.initIsToday,
      };
    }
  }

  //---------- build method
  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(_categoryColor);
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
    if (picked != null) {
      setState(() {
        int intPicked = ToDoItem.toSortableDate(picked);
        _formData['itemScheduledDate'] = intPicked;
        _formData['itemIsToday'] = false;
      });
    }
  }

  //---------- today picker
  void _selectToday() {
    setState(() {
      _formData['itemIsToday'] = !_formData['itemIsToday'];
    });
  }

  //---------- category picker popup
  Future _selectCategory() async {
    AppState appState = ScopedModel.of<AppState>(context);
    List<Category> categories = appState.categories;
    List<Widget> options = [];
    int picked;

    for (var i = 0; i < categories.length; i++) {
      options.add(
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, i);
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Text(
                  categories[i].name,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            color: categories[i].color,
            height: 80.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
          ),
        ),
      );
    }

    picked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: options,
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      height: AppConstants.headerHeight,
      color: _categoryColor,
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(color: Colors.white),
          textCapitalization: TextCapitalization.words,
          initialValue: _formData['itemTitle'],
          autofocus: true,
          onSaved: (String value) {
            _formData['itemTitle'] = value;
          },
          decoration: InputDecoration(
            hintText: 'Do Something',
            labelText: 'Title',
            labelStyle: TextStyle(color: Colors.white),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  //---------- item options (main body)
  Widget _buildListView() {
    print("isToday: " + _formData['itemIsToday'].toString());

    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListTile(
          leading: _formData['itemIsToday']
              ? Icon(
                  Icons.event_available,
                  color: _categoryColor,
                )
              : Icon(
                  Icons.event_available,
                  color: Colors.grey,
                ),
          title: Text('Today'),
          subtitle: Text("Display item on the Today list"),
          onTap: _selectToday,
        ),
        ListTile(
          leading: Icon(Icons.category, color: _categoryColor),
          title: Text('Category'),
          subtitle: Text("Pick this item's category"),
          onTap: _selectCategory,
        ),
        ListTile(
          trailing: _formData['itemScheduledDate'] == 0
              ? null
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _formData['itemScheduledDate'] = 0;
                    });
                  },
                ),
          leading: _formData['itemScheduledDate'] == 0
              ? Icon(
                  Icons.today,
                  color: Colors.grey,
                )
              : Icon(
                  Icons.today,
                  color: _categoryColor,
                ),
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

            //---------- handle adding a new item
            if (_isNewItem) {
              ToDoItem _newItem = ToDoItem(title: _formData['itemTitle']);
              if (_formData['itemScheduledDate'] != null) {
                _newItem.scheduledDate = _formData['itemScheduledDate'];
              }
              if (_formData['itemIsToday']) {
                _newItem.isToday = true;
              }
              appState.addItemToCategory(_categoryIndex, _newItem);
            }
            //---------- handle updating an existing item + category change
            else if (_categoryIndex != _originalCategoryIndex) {
              appState.updateItemMoveCategory(
                originalCategoryIndex: _originalCategoryIndex,
                newCategoryIndex: _categoryIndex,
                itemIndex: _itemIndex,
                newTitle: _formData['itemTitle'],
                newIsToday: _formData['itemIsToday'],
                newScheduledDate: _formData['itemScheduledDate'],
              );
            }
            //---------- handle updating an existing item
            else {
              appState.updateItemInCategory(
                categoryIndex: _categoryIndex,
                itemIndex: _itemIndex,
                newTitle: _formData['itemTitle'],
                newIsToday: _formData['itemIsToday'],
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
