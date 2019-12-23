import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

import 'package:today/models/todo_item.dart';
import 'package:today/models/app_state.dart';
import 'package:today/models/category.dart';
import 'package:today/models/app_constants.dart';
import '../widgets/repeater_picker.dart';

class ItemPage extends StatefulWidget {
  final int categoryIndex;
  final int itemIndex;
  bool initIsToday;

  ItemPage(
      {@required this.categoryIndex,
      this.itemIndex,
      @required this.initIsToday});

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
  int _repeatNum = 1;
  String _repeatLen = 'days';

  @override
  void initState() {
    super.initState();

    _categoryIndex = widget.categoryIndex;
    _originalCategoryIndex = widget
        .categoryIndex; //used to detect if category was changed before saving
    var appState = ScopedModel.of<AppState>(context);
    var category = appState.categories[_categoryIndex];
    _categoryColor = category.color;
    _categoryTitle = category.name;

    if (widget.itemIndex != null) {
      // form data for existing item
      var _item = category.items[widget.itemIndex];
      _itemIndex = widget.itemIndex;
      _isNewItem = false;

      _formData = {
        "itemTitle": _item.title,
        "itemScheduledDate": _item.scheduledDate,
        "itemIsToday": _item.isToday,
        "itemRepeatNum": _item.repeatNum,
        "itemRepeatLen": _item.repeatLen
      };
    } else {
      // form data for a new item
      _formData = {
        "itemTitle": null,
        "itemScheduledDate": 0,
        "itemIsToday": widget.initIsToday,
        "itemRepeatNum": 0,
        "itemRepeatLun": "days"
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
      resizeToAvoidBottomInset: false,
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

  //---------- repeat picker
  Future _selectRepeat() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: RepeatPicker(_updateRepeatValues),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  _formData['itemRepeatNum'] = _repeatNum;
                  _formData['itemRepeatLen'] = _repeatLen;
                  print("repeatNum: " +
                      _repeatNum.toString() +
                      " repeatLen: " +
                      _repeatLen);
                });
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  void _updateRepeatValues(String newNum, String newLen) {
    setState(() {
      _repeatNum = int.parse(newNum);
      _repeatLen = newLen;
    });
  }

  // //---------- days picker popup
  // Future _displayDialog(BuildContext context) async {
  //   TextEditingController _textFieldController = TextEditingController();

  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('TextField in Dialog'),
  //           content: TextField(
  //             controller: _textFieldController,
  //             decoration: InputDecoration(hintText: "TextField in Dialog"),
  //           ),
  //           actions: <Widget>[
  //             new FlatButton(
  //               child: new Text('CANCEL'),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             )
  //           ],
  //         );
  //       });
  // }

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
          subtitle: Text(_categoryTitle),
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
              ? Icon(Icons.today, color: Colors.grey)
              : Icon(Icons.today, color: _categoryColor),
          title: Text('Schedule'),
          subtitle:  _formData['itemScheduledDate'] == 0
            ? Text("Set a due date")
            : Text(_formData['itemScheduledDate'].toString()), //this could be formatted nicer
          onTap: _selectDate,
        ),
        ListTile(
          trailing: _formData['itemRepeatNum'] == 0
              ? null
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _formData['itemRepeatNum'] = 0;
                    });
                  },
                ),
          leading: _formData['itemRepeatNum'] == 0
              ? Icon(Icons.repeat, color: Colors.grey)
              : Icon(Icons.repeat, color: _categoryColor),
          title: Text("Repeat"),
          subtitle: _formData['itemRepeatNum'] == 0
            ? Text("Set a recurring schedule")
            : Text("Every " + _formData['itemRepeatNum'].toString() + " " + _formData['itemRepeatLen']),
          onTap: _selectRepeat,
        )
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
              if (_formData['itemScheduledDate'] != 0) {
                _newItem.scheduledDate = _formData['itemScheduledDate'];
              }
              if (_formData['itemIsToday']) {
                _newItem.isToday = true;
              }
              if (_formData['itemRepeatNum'] != 0) {
                _newItem.repeatNum = _formData['itemRepeatNum'];
                _newItem.repeatLen = _formData['itemRepeatLen'];
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
                newRepeatNum: _formData['itemRepeatNum'],
                newRepeatLen: _formData['itemRepeatLen'],
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
                newRepeatNum: _formData['itemRepeatNum'],
                newRepeatLen: _formData['itemRepeatLen'],
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
