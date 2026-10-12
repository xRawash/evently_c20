import 'package:evently_app_abbas/models/category_model.dart';
import 'package:flutter/material.dart';

class CustomTabItem extends StatelessWidget {
  const CustomTabItem({
    super.key,
    required this.category,
    required this.selectedBgColor,
    required this.selectedFgColor,
    required this.unSelectedBgColor,
    required this.unSelectedFgColor,
    required this.isSelected,
  });

  final CategoryModel category;
  final Color selectedBgColor;
  final Color unSelectedBgColor;
  final Color selectedFgColor;
  final Color unSelectedFgColor;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : unSelectedBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            category.icon,
            color: isSelected ? selectedFgColor : unSelectedFgColor,
          ),
          const SizedBox(width: 8),
          Text(
            category.name,
            style: TextStyle(
              color: isSelected ? selectedFgColor : unSelectedFgColor,
            ),
          )
        ],
      ),
    );
  }
}
