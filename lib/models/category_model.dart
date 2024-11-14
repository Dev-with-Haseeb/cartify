import 'package:flutter/material.dart';

class Category {
  final String id;
  final String name;
  final String icon;

  Category({required this.id, required this.name, required this.icon});
}


IconData getIconFromString(String iconName) {
  switch (iconName) {
    case 'male':
      return Icons.male;
    case 'female':
      return Icons.female;
    case 'child_friendly':
      return Icons.child_friendly;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'sports_football':
      return Icons.sports_football;
    case 'diamond':
      return Icons.diamond;
    case 'watch':
      return Icons.watch;
    default:
      return Icons.help;  // Default icon if none match
  }
}
