import 'package:flutter/material.dart';

class ToDoItem {
  String title;
  UniqueKey key = UniqueKey();
  bool isComplete = false;
  bool isToday = false;


  ToDoItem({
    @required this.title 
  });
}