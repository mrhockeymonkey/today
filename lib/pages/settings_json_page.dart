import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_state.dart';
import '../models/category.dart';

class SettingsJsonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsJsonPageState();
  }
}

class _SettingsJsonPageState extends State<SettingsJsonPage> {
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
    var a = appState.getJson();
    //print(a);
    //List<Category> categories = appState.categories;

    return Column(
      children: <Widget>[
        FlatButton(
          child: Text("Copy To Clipboard"),
          color: Colors.blue,
          onPressed: () => {
            Clipboard.setData(ClipboardData(text: a)),
            print("copied to clipboard")
          },
        ),
        Text(a),
      ],
    );
    // return Container(
    //   children:
    //   //child: Text(a)
    //   //child: TextBox.fromLTRBD(left, top, right, bottom, direction)

    // );
  }

  // _displayDialog(BuildContext context) async {
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
}
