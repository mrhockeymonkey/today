import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../widgets/checkbox_picker.dart';
import '../models/app_state.dart';
import '../models/category.dart';
import '../models/app_constants.dart';
import '../widgets/icon_picker.dart';

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
        backgroundColor: AppConstants.appBarColor,
        title: Text("Categories"),
        elevation: 0.0,
      ),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton(
      child: Icon(Icons.done),
      backgroundColor: AppConstants.appBarColor,
      onPressed: () {
        Navigator.of(context).pop();
      },
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
          int categoryIndex = appState.categories.indexOf(category);

          return Card(
            color: category.color,
            elevation: 0.0,
            child: ListTile(
              isThreeLine: true,
              leading: Icon(AppConstants.icons[category.iconName]),
              title: Text(category.name),
              subtitle: appState.defaultCategoryIndex == index
                  ? Text("Default")
                  : Text(""),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _displayDialog(context, categoryIndex),
              ),
            ),
          );
        },
      ),
    );
  }

  _displayDialog(BuildContext context, int categoryIndex) async {
    AppState appState = ScopedModel.of<AppState>(context);
    _textFieldController.clear();
    Category thisCategory = appState.categories[categoryIndex];
    String currentCategoryName = thisCategory.name;
    String currentIconName = thisCategory.iconName;
    bool isDefaultCategory = false;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Category'),
            content: Column(
              children: [
                Row(
                  children: [
                    Text("Name:"),
                    FittedBox(),
                  ],
                ),
                TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: currentCategoryName),
                  onChanged: (String newName) {
                    currentCategoryName = newName;
                  },
                ),
                Container(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("Icon:"),
                    FittedBox(),
                  ],
                ),
                IconPicker((String newIconName) {
                  currentIconName = newIconName;
                }),
                Container(
                  height: 20,
                ),
                Row(
                  children: [
                    Text("Default:"),
                    FittedBox(),
                  ],
                ),
                CheckboxPicker(
                  initialValue: isDefaultCategory,
                  updateValue: (bool newValue) {
                    isDefaultCategory = newValue;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  setState(() {
                    appState.updateCategoryName(
                        categoryIndex: categoryIndex,
                        newName: currentCategoryName.toUpperCase(),
                        newIconName: currentIconName);
                    if (isDefaultCategory) {
                      appState.setDefaultCategory(categoryIndex);
                    }
                    Navigator.of(context).pop();
                  });
                },
              ),
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
