// themes.dart
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black38,
  colorScheme: ColorScheme.dark(
    background: Colors.grey[800]!,
    primary: Colors.grey[700]!,
    secondary: Colors.grey,
  ),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white38,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey[100]!,
    secondary: Colors.grey[200]!,
  ),
);
