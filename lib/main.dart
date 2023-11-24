import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:QuoteLens/pages/auth_page.dart';
import 'package:QuoteLens/themes/themes.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData(
          cupertinoOverrideTheme: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(), // This is required
          ),
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
          primarySwatch: Colors.grey,
          primaryColor: Colors.white,
          scaffoldBackgroundColor: Colors.white38,
          colorScheme: ColorScheme.light(
            background: Colors.white,
            primary: Colors.grey[100]!,
            secondary: Colors.grey[200]!,
          )),
      dark: ThemeData(
          cupertinoOverrideTheme: const CupertinoThemeData(
            textTheme: CupertinoTextThemeData(), // This is required
          ),
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
          primarySwatch: Colors.grey,
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.black38,
          colorScheme: ColorScheme.dark(
            background: Colors.grey[800]!,
            primary: Colors.grey[700]!,
            secondary: Colors.grey,
          )),
      initial: savedThemeMode ?? AdaptiveThemeMode.dark,
      builder: (theme, darkTheme) => MaterialApp(
        title: 'QuoteLens',
        debugShowCheckedModeBanner: false,
        home: const AuthPage(savedThemeMode: AdaptiveThemeMode.dark),
        theme: theme,
        darkTheme: darkTheme,
      ),
    );
  }
}
