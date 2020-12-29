import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeBackground extends StatelessWidget {
  final MainAxisAlignment align;
  final String text;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  SwipeBackground({
    @required this.align,
    @required this.text,
    @required this.icon,
    @required this.bgColor,
    @required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      color: bgColor,
      child: Row(
        mainAxisAlignment: align,
        children: <Widget>[
          Icon(
            icon,
            color: iconColor,
          ),
          Text(text)
        ],
      ),
    );
  }
}
