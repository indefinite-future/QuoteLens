// themes.dart
import 'package:flutter/material.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static Future<Theme> getTheme(Theme darkTheme, Theme lightTheme) async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    return isDarkMode ? darkTheme : lightTheme;
  }

  static Future<void> setTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }
}

class MyAppsTheme {
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black38,
      colorScheme: ColorScheme.dark(
        background: Colors.grey[800]!,
        primary: Colors.grey[700]!,
        secondary: Colors.grey,
      ));

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white38,
      colorScheme: ColorScheme.light(
        background: Colors.white,
        primary: Colors.grey[100]!,
        secondary: Colors.grey[200]!,
      ));

  static ThemeData currentTheme = lightTheme;

  static Future<Theme> getCurrentTheme() async {
    return await ThemeService.getTheme(darkTheme as Theme, lightTheme as Theme);
  }
}
