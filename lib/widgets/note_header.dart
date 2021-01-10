import 'package:flutter/material.dart';

import '../models/app_constants.dart';

class NoteHeader extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const NoteHeader({
    @required this.text,
    this.backgroundColor = Colors.grey,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: backgroundColor,
      height: AppConstants.headerHeight / 2,
      child: Container(
        alignment: Alignment(0.0, 0.0),
        child: Text(
          text,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
