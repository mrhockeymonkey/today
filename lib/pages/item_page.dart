import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import '../models/todo_item.dart';
import '../models/app_state.dart';
import '../models/category.dart';
import '../models/app_constants.dart';
import '../widgets/repeater_picker.dart';

class ItemPage extends StatefulWidget {
  final int categoryIndex;
  final int itemIndex;
  final bool initIsToday;
  final bool focusKeyboard;

  ItemPage({
    @required this.categoryIndex,
    this.itemIndex,
    @required this.initIsToday,
    @required this.focusKeyboard,
  });

  @override
  State<StatefulWidget> createState() {
    return _ItemPageState();
  }
}

class _ItemPageState extends State<ItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
        "itemRepeatLen": _item.repeatLen,
        "itemSeriesLen": _item.seriesLen
      };
    } else {
      // form data for a new item
      _formData = {
        "itemTitle": null,
        "itemScheduledDate": 0,
        "itemIsToday": widget.initIsToday,
        "itemRepeatNum": 0,
        "itemRepeatLen": "days",
        "itemSeriesLen": 0
      };
    }
  }

  //---------- build method
  @override
  Widget build(BuildContext context) {
    //AppConstants.changeStatusColor(_categoryColor);
    //AppConstants.changeNavBarColor(_categoryColor);
    print("BUILD - item_page");

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          backgroundColor: _categoryColor,
          elevation: 0.0,
          title: Text(_categoryTitle)),
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

  //---------- today picker popup
  // Future _selectToday() async {
  //   int picked;

  //   picked = await showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return SimpleDialog(
  //         children: <Widget>[
  //           SimpleDialogOption(
  //             onPressed: () {
  //               Navigator.pop(context, 0);
  //             },
  //             child: Container(
  //               child: Row(
  //                 children: <Widget>[
  //                   Text(
  //                     "TODAY",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //               color: _categoryColor,
  //               height: 80.0,
  //               padding: EdgeInsets.symmetric(horizontal: 10.0),
  //             ),
  //           ),
  //           SimpleDialogOption(
  //             onPressed: () {
  //               Navigator.pop(context, 1);
  //             },
  //             child: Container(
  //               child: Row(
  //                 children: <Widget>[
  //                   Text(
  //                     "BACKLOG",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ],
  //               ),
  //               color: Colors.grey,
  //               height: 80.0,
  //               padding: EdgeInsets.symmetric(horizontal: 10.0),
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );

  //   print(picked);
  //   if (picked != null)
  //     setState(() {
  //       _formData['itemIsToday'] = picked == 0 ? true : false;
  //     });
  // }

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

  //---------- series picker popup
  Future _selectSeries() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  style: TextStyle(decoration: TextDecoration.none, ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  maxLengthEnforced: false,
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  enabled: true,
                  onSubmitted: (String text) {
                    int numberInput = int.parse(text);
                    setState(() {
                      _formData['itemSeriesLen'] = numberInput;
                    });
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Expanded(
                child: Text(" occurrences left"),
              )
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            // FlatButton(
            //   child: Text('OK'),
            //   onPressed: () {
            //     setState(() {
            //       _formData['itemSeriesLen'] = 1;
            //     });
            //     Navigator.of(context).pop();
            //   },
            // )
          ],
        );
      },
    );
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
          autofocus: widget.focusKeyboard,
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
                  AppConstants.categoryIcons[_categoryIndex],
                  color: _categoryColor,
                )
              : Icon(
                  AppConstants.categoryIcons[_categoryIndex],
                  color: Colors.grey,
                ),
          title: Text(
              "Focus"), //_formData['itemIsToday'] ? Text("Focus") : Text("Backlog"),
          subtitle: _formData['itemIsToday']
              ? Text('You are focused on this task')
              : Text('You are not focusing on this task'),
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
          subtitle: _formData['itemScheduledDate'] == 0
              ? Text("Set a due date")
              : Text(DateFormat.MMMMEEEEd()
                  .format(ToDoItem.toDateTime(_formData['itemScheduledDate']))),
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
              : Text("Every " +
                  _formData['itemRepeatNum'].toString() +
                  " " +
                  _formData['itemRepeatLen']),
          onTap: _selectRepeat,
        ),

        //---------- series tile
        ListTile(
          trailing: _formData['itemSeriesLen'] == 0
              ? null
              : IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      _formData['itemSeriesLen'] = 0;
                    });
                  },
                ),
          leading: _formData['itemSeriesLen'] == 0
              ? Icon(Icons.slideshow, color: Colors.grey)
              : Icon(Icons.slideshow, color: _categoryColor),
          title: Text("Series"),
          subtitle: _formData['itemSeriesLen'] == 0
              ? Text("Set number occurences (or episodes)")
              : Text("${_formData['itemSeriesLen']} occurences left"),
          onTap: _selectSeries,
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
              if (_formData['itemSeriesLen'] > 0) {
                _newItem.seriesLen = _formData['itemSeriesLen'];
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
                newSeriesLen: _formData['itemSeriesLen'],
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
                newSeriesLen: _formData['itemSeriesLen'],
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
