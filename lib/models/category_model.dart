import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryModel{
  String id;
  String name;
  IconData icon;
  String image;
  CategoryModel({required this.id, required this.name, required this.icon, required this.image});


 // static List<CategoryModel> categoriesWithAll = [
 //
 //    CategoryModel(id: "1", name: "All", icon: Icons.all_inclusive, image: ImageAssets.meeting),
 //    CategoryModel(id: "2", name: "Sports", icon: Icons.sports_football,image: ImageAssets.meeting),
 //    CategoryModel(id: "3", name: "Book Club", icon: Icons.bookmark_add_rounded,image: ImageAssets.meeting),
 //    CategoryModel(id: "4", name: "Birthday", icon: Icons.cake_outlined,image: ImageAssets.meeting),
 //    CategoryModel(id: "5", name: "Meeting", icon: Icons.laptop_chromebook,image: ImageAssets.meeting),
 //    CategoryModel(id: "6", name: "Exhibition", icon: Icons.water_drop_rounded,image: ImageAssets.meeting),
 //
 //  ];
 static List<CategoryModel> getCategories (BuildContext context){
   bool isDark = Theme.of(context).brightness == Brightness.dark;
   return [

  CategoryModel(id: "1", name: AppLocalizations.of(context)!.sports, icon: Icons.sports_football,image: isDark ?ImageAssets.sportDark:ImageAssets.sportLight),
  CategoryModel(id: "2", name: AppLocalizations.of(context)!.bookClub, icon: Icons.bookmark_add_rounded,image: isDark? ImageAssets.bookClubDark:ImageAssets.bookClubLight),
  CategoryModel(id: "3", name: AppLocalizations.of(context)!.birthday, icon: Icons.cake_outlined,image: isDark? ImageAssets.birthdayDark:ImageAssets.birthdayLight),
  CategoryModel(id: "4", name: AppLocalizations.of(context)!.meeting, icon: Icons.laptop_chromebook,image: isDark? ImageAssets.meetingDark: ImageAssets.meetingLight),
  CategoryModel(id: "5", name: AppLocalizations.of(context)!.exhibition, icon: Icons.water_drop_rounded,image: isDark? ImageAssets.exhibitionDark:ImageAssets.exhibitionLight),

  ];
}
}