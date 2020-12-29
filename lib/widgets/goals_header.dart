import 'package:flutter/material.dart';

import '../models/app_constants.dart';

class GoalsHeader extends StatelessWidget {
  String text;
  Color backgroundColor;
  Color textColor;

  // GoalsHeader(
  //     {@required this.text,
  //     this.backgroundColor = Colors.grey,
  //     this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: backgroundColor,
      height: AppConstants.headerHeight / 2,
      child: Row(
        children: [Text("foo"), Icon(Icons.edit)],
      ),
      // Container(
      //   alignment: Alignment(0.0, 0.0),
      //   child: Text(
      //     text,
      //     style: TextStyle(color: textColor),
      //   ),
      // ),
    );
  }
}
