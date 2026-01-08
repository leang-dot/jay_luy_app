import 'package:flutter/material.dart';

class Category {
  final String name;
  final IconData icon;

  Category({required this.name, required this.icon});

  static List<Category> get categories => [
    Category(name: "Food", icon: Icons.restaurant),
    Category(name: "Transport", icon: Icons.directions_car),
    Category(name: "Shopping", icon: Icons.shopping_bag),
    Category(name: "Entertainment", icon: Icons.movie),
    Category(name: "Bills", icon: Icons.receipt_long),
  ];
}