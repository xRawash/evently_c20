import 'package:evently_app_abbas/prefs_manager/prefs_manager.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigProvider extends ChangeNotifier {
  ThemeMode currentTheme = PrefsManager.getSavedTheme() ?? ThemeMode.light;
  String currentLang = PrefsManager.getSavedLanguage() ?? 'en';
  bool get isDark => currentTheme == ThemeMode.dark;
  bool get isEnglish => currentLang == 'en';
  void changeAppTheme (ThemeMode newTheme) async {
    currentTheme = newTheme;
    PrefsManager.saveCurrentTheme(currentTheme);
    notifyListeners();
  }
  void changeAppLanguage (String newLang) {
    if(currentLang == newLang) return;
    currentLang = newLang;
    PrefsManager.saeCurrentLanguage(currentLang);
    notifyListeners();
  }
}