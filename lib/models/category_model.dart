import 'package:evently_app_abbas/core/sources/assets_manager.dart';
import 'package:evently_app_abbas/l10n/app_localizations.dart';
import 'package:evently_app_abbas/providers/config_provider.dart';
import 'package:flutter/material.dart';

class CategoryModel{
  String id;
  String name;
  IconData icon;
  String image;
  static ConfigProvider? config;
  CategoryModel({required this.id, required this.name, required this.icon, required this.image});
 static bool isDark = config!.isDark;
  static List<CategoryModel> get categories {
    final isDark = config?.isDark ?? false;
    final l10n = lookupAppLocalizations(config?.locale ?? const Locale('en'));

    return [
      CategoryModel(id: '1', name: l10n.sports, icon: Icons.sports_football,
          image: isDark ? ImageAssets.sportDark : ImageAssets.sportLight),
      CategoryModel(id: '2', name: l10n.bookClub, icon: Icons.bookmark_add_rounded,
          image: isDark ? ImageAssets.bookClubDark : ImageAssets.bookClubLight),
      CategoryModel(id: '3', name: l10n.birthday, icon: Icons.cake_outlined,
          image: isDark ? ImageAssets.birthdayDark : ImageAssets.birthdayLight),
      CategoryModel(id: '4', name: l10n.meeting, icon: Icons.laptop_chromebook,
          image: isDark ? ImageAssets.meetingDark : ImageAssets.meetingLight),
      CategoryModel(id: '5', name: l10n.exhibition, icon: Icons.water_drop_rounded,
          image: isDark ? ImageAssets.exhibitionDark : ImageAssets.exhibitionLight),
    ];
  }
}