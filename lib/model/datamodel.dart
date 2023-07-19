import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other
}

class Category {
  Category(this.title, this.color);
  final String title;
  final Color color;
}

class GroceryItem {
  GroceryItem(
      {required this.id,
      required this.name,
      required this.category,
      required this.quantity});
  String id;
  String name;
  int quantity;
  final Category category;
}
