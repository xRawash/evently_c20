import 'dart:ui';

import 'package:evently_app_abbas/core/sources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsManager {
  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void saveCurrentTheme(ThemeMode currentTheme) async {
    String theme = currentTheme == ThemeMode.dark ? 'Dark' : 'Light';
    prefs.setString('current_theme', theme);
  }

  static ThemeMode? getSavedTheme() {
    String? savedTheme = prefs.getString('current_theme');
    if (savedTheme == 'Light') {
      return ThemeMode.light;
    } else if (savedTheme == 'Dark') {
      return ThemeMode.dark;
    } else {
      return null;
    }
  }

  static void saeCurrentLanguage(String currentLanguage) async {
    prefs.setString('current_language', currentLanguage);
  }

  static String? getSavedLanguage() {
    String? savedLanguage = prefs.getString('current_language');
    if (savedLanguage == 'en') {
      return 'en';
    } else if (savedLanguage == 'ar') {
      return 'ar';
    } else {
      return null;
    }
  }

  static void finishedOnBoarding(BuildContext context) {
    prefs.setBool('finished_onboarding', true);
    Navigator.pushReplacementNamed(context, RoutesManager.register);
  }

  static bool? getFinishedOnBoarding() {
    return prefs.getBool('finished_onboarding');
  }
}
