import 'package:evently_app_abbas/core/widgets/custom_tab_item.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
  CustomTabBar({
    super.key,
    required this.categories,
    required this.selectedBgColor,
    required this.selectedFgColor,
    required this.unSelectedBgColor,
    this.onSelectedCategoryClicked,
    required this.unSelectedFgColor,
    this.initialCategory,
  });

  List<CategoryModel> categories;
  Color selectedBgColor;
  Color unSelectedBgColor;
  Color selectedFgColor;
  Color unSelectedFgColor;
  void Function(CategoryModel)? onSelectedCategoryClicked;
  CategoryModel? initialCategory;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      int foundIndex = widget.categories.indexWhere(
        (c) => c.id == widget.initialCategory!.id,
      );
      if (foundIndex != -1) {
        selectedIndex = foundIndex;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.categories.length,
      initialIndex: selectedIndex,
      child: TabBar(
        onTap: (newIndex) {
          setState(() {
            selectedIndex = newIndex;
            widget.onSelectedCategoryClicked?.call(
              widget.categories[selectedIndex],
            );
          });
        },
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        isScrollable: true,
        tabs: widget.categories
            .map(
              (category) => CustomTabItem(
                category: category,
                selectedBgColor: widget.selectedBgColor,
                selectedFgColor: widget.selectedFgColor,
                unSelectedBgColor: widget.unSelectedBgColor,
                unSelectedFgColor: widget.unSelectedFgColor,
                isSelected:
                    widget.categories.indexOf(category) == selectedIndex,
              ),
            )
            .toList(),
      ),
    );
  }
}
