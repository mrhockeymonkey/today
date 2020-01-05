import 'package:flutter/material.dart';
//import '../pages/settings_json.dart';

import './settings_categories_page.dart';
import './settings_json_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingsPageState();
  }
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Settingssss"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              // Backup
              ListTile(
                leading: Icon(Icons.code),
                title: Text("View JSON"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsJsonPage()));
                },
              ),
              // Categories
              ListTile(
                leading: Icon(Icons.category),
                title: Text("Categories"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SettingsCategoriesPage()),
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
