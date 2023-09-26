import 'package:flutter/material.dart';
import 'package:fypv2/pages/auth_screen.dart';
import 'package:fypv2/themes/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FYP version 2',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: MyAppsTheme.currentTheme,
    );
  }
}
