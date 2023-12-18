import 'package:flutter/material.dart';
import 'package:QuoteLens/themes/themes.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;

  bool get isDarkModeOn => _themeData == darkTheme;

  ThemeData getTheme() => _themeData;

  setTheme(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    _themeData = _themeData == lightTheme ? darkTheme : lightTheme;
    notifyListeners();
  }
}
