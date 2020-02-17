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
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        AppConstants.headerTextDate,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "${headerCount.toString()} Things Done Today",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                  //headerContent ?? AppConstants.headerTextDate,
                  )),
          // Icon(
          //   Icons.search,
          //   color: Colors.white,
          // ),
        ],
      ),
    );
  }
}
