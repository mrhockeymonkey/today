import 'package:flutter/material.dart';

import 'package:today/models/app_constants.dart';

class CategoryHeader extends StatelessWidget {
  final Color headerColor;
  final int headerCount;

  CategoryHeader({
    @required this.headerColor,
    @required this.headerCount
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      color: headerColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text('Keep it up'),
          ),
          CircleAvatar(
            child: Text(headerCount.toString()),
            radius: AppConstants.cirleAvatarRadius, //sized to match floating action button
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }
}
