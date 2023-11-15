import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:QuoteLens/pages/auth_page.dart';
import 'package:QuoteLens/themes/themes.dart';
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
      title: 'QuoteLens',
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      darkTheme: ThemeData(
        cupertinoOverrideTheme: const CupertinoThemeData(
          textTheme: CupertinoTextThemeData(), // This is required
        ),
      ),
      //theme: MyAppsTheme.currentTheme,
    );
  }
}
