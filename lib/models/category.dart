import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import '../utils/app_colors.dart';

class Category extends Equatable {
  final String name;
  final IconData icon;
  final Color color;

  const Category({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object> get props => [name, icon, color];

  static const List<Category> predefinedCategories = [
    Category(
      name: 'Groceries',
      icon: Icons.shopping_cart,
      color: AppColors.groceries,
    ),
    Category(
      name: 'Entertainment',
      icon: Icons.movie,
      color: AppColors.entertainment,
    ),
    Category(
      name: 'Gas',
      icon: Icons.local_gas_station,
      color: AppColors.gas,
    ),
    Category(
      name: 'Shopping',
      icon: Icons.shopping_bag,
      color: AppColors.shopping,
    ),
    Category(
      name: 'News Paper',
      icon: Icons.newspaper,
      color: AppColors.newspaper,
    ),
    Category(
      name: 'Transport',
      icon: Icons.directions_car,
      color: AppColors.transport,
    ),
    Category(
      name: 'Rent',
      icon: Icons.home,
      color: AppColors.rent,
    ),
  ];

  static Category? getCategoryByName(String name) {
    try {
      return predefinedCategories.firstWhere((cat) => cat.name == name);
    } catch (e) {
      return null;
    }
  }
} 