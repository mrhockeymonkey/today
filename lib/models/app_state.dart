import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './todo_category.dart';

class AppState extends Model {
  // for now we just declare categories here until we can save data to phone
  List<Category> _categories = [
    Category(name: 'FOCUS', color: const Color(0xFFEE534F)),
    Category(name: 'GOALS', color: const Color(0xFF00B8D4)),
    Category(name: 'FIT IN', color: const Color(0xFFFBAF28)),
    Category(name: 'BACKBURNER', color: const Color(0xFF01BFA5))
  ];

  // the today category is immutable, core principal of the apps purpose
  //final Category today = Category(name: 'TODAY', color: const Color(0xFF6A88BA));

  // getter for categories
  List<Category> get categories {
    return List.from(_categories);
  }
}
