import 'package:flutter/material.dart';

import '../models/app_constants.dart';

class CategoryHeader extends StatelessWidget {
  final Color headerColor;
  final int headerCount;
  final Widget headerContent;

  CategoryHeader({
    @required this.headerColor,
    @required this.headerCount, 
    this.headerContent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: AppConstants.headerHeight,
      color: headerColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: headerContent ?? AppConstants.headerTextDate,
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            )
            
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
