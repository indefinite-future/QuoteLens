// themes.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.grey[800],
  colorScheme: ColorScheme.dark(
    background: Colors.grey[800]!,
    primary: Colors.grey[700]!,
    secondary: Colors.grey,
    tertiary: Colors.white,
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(color: Colors.black),
    ), // This is required
  ),
);

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.grey[100]!,
    secondary: Colors.grey[200]!,
    tertiary: Colors.grey,
  ),
  cupertinoOverrideTheme: const CupertinoThemeData(
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(color: Colors.black),
    ), // This is required
  ),
);
