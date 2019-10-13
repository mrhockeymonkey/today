import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_state.dart';
import '../models/category.dart';

class SettingsCategoriesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsCategoriesPageState();
  }
}

class _SettingsCategoriesPageState extends State<SettingsCategoriesPage> {
  TextEditingController _textFieldController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Categories"),
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    AppState appState = ScopedModel.of<AppState>(context);
    List<Category> categories = appState.categories;

    return Container(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          Category category = categories[index];
          return Card(
            color: category.color,
            elevation: 0.0,
            child: ListTile(
              title: Text(category.name),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _displayDialog(context),
              ),
            ),
          );
        },
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('TextField in Dialog'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "TextField in Dialog"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}