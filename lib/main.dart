import 'package:flutter/material.dart';
import 'package:fypv2/pages/login_screen.dart';
import 'package:fypv2/themes/themes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FYP version 2',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: MyAppsTheme.currentTheme,
    );
  }
}
