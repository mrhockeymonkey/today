import 'package:flutter/material.dart';

import '../models/app_constants.dart';

class IconPicker extends StatefulWidget {
  final Function updateIconValue;

  IconPicker(this.updateIconValue);

  @override
  State<StatefulWidget> createState() {
    return _IconPickerState();
  }
}

class _IconPickerState extends State<IconPicker> {
  final List<String> iconChoice = AppConstants.icons.keys.toList();
  String currentIconName = "pin";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton<String>(
        value: currentIconName,
        items: iconChoice.map((String iconName) {
          return new DropdownMenuItem<String>(
            value: iconName,
            child: Icon(AppConstants.icons[iconName]),
          );
        }).toList(),
        onChanged: (String newValue) {
          setState(() {
            currentIconName = newValue;
            widget.updateIconValue(newValue);
          });
        },
      ),
    );
  }
}
