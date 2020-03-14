import 'package:flutter/material.dart';
//import '../pages/settings_json.dart';

import './settings_categories_page.dart';
import './settings_json_page.dart';
import '../models/app_constants.dart';

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
        backgroundColor: AppConstants.appBarColor,
        elevation: 0.0,
        title: Text("Settings"),
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
                leading: Icon(
                  Icons.code,
                  color: AppConstants.appBarColor,
                ),
                title: Text("Backup Data"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingsJsonPage()));
                },
              ),
              // Categories
              ListTile(
                leading: Icon(
                  Icons.category,
                  color: AppConstants.appBarColor,
                ),
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
