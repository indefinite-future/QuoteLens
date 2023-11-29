import 'package:QuoteLens/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

import '../themes/themes.dart';

class UserPage extends StatefulWidget {
  UserPage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign out function
  void signUserOut() async {
    // sign out user
    // if successful, navigate to login page
    // else, show error message
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text(
              "Logged in as: ${widget.user.email!}",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),

            //logout button
            ElevatedButton(
              child: const Text('Logout'),
              onPressed: () {
                widget.signUserOut();
              },
            ),

            //toggle theme button
            const Text("Toggle Theme:"),
            ElevatedButton(
              child: const Text('Light'),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setTheme(lightTheme);
              },
            ),
            ElevatedButton(
              child: const Text('Dark'),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false)
                    .setTheme(darkTheme);
              },
            ),
          ],
        ),
      ),
    );
  }
}
