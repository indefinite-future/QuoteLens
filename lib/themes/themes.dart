// themes.dart
import 'package:flutter/material.dart';

class MyAppsTheme {
  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black38,
      colorScheme: ColorScheme.dark(
        background: Colors.grey[900]!,
        primary: Colors.grey[800]!,
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

  static ThemeData currentTheme = darkTheme;
}
