import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/app_state.dart';
import '../models/app_constants.dart';

class SettingsJsonPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsJsonPageState();
  }
}

class _SettingsJsonPageState extends State<SettingsJsonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.appBarColor,
        title: Text("Backup Data"),
        elevation: 0.0,
      ),
      body: _buildBody(),
    );
  }

  _buildBody() {
    AppState appState = ScopedModel.of<AppState>(context);
    var json = appState.getJson();

    return Column(
      children: <Widget>[
        FlatButton(
          child: Text(
            "Copy To Clipboard",
            style: TextStyle(color: Colors.white),
          ),
          color: AppConstants.appBarColor,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: json));
            print("copied to clipboard");
          },
        ),
        Text(json),
      ],
    );
  }
}
