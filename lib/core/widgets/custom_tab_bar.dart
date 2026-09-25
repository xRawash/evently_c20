import 'package:evently_app_abbas/core/sources/colors_manager.dart';
import 'package:evently_app_abbas/core/widgets/custom_tab_item.dart';
import 'package:evently_app_abbas/models/category_model.dart';
import 'package:flutter/material.dart';

class CustomTabBar extends StatefulWidget {
   CustomTabBar({super.key, required this.categories, required this.selectedBgColor, required this.selectedFgColor, required this.unSelectedBgColor, required this.unSelectedFgColor});
List<CategoryModel> categories;

   Color selectedBgColor;
   Color unSelectedBgColor;
   Color selectedFgColor;
   Color unSelectedFgColor;

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {

  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: widget.categories.length,
      child: TabBar(
        onTap: (newIndex){
          setState(() {
            selectedIndex = newIndex;
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
            selectedBgColor:widget.selectedBgColor,
            selectedFgColor: widget.selectedFgColor,
            unSelectedBgColor: widget.unSelectedBgColor,
            unSelectedFgColor:widget.unSelectedFgColor,
            isSelected: widget.categories.indexOf(category) == selectedIndex,
          ),
        )
            .toList(),
      ),
    );
  }
}
