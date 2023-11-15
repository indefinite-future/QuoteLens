import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:QuoteLens/pages/bottomnav.dart';
import 'package:QuoteLens/pages/login_or_register_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance
              .authStateChanges(), //check whether the user is login or not

          builder: (context, snapshot) {
            //if the user is login
            if (snapshot.hasData) {
              return const BottomNav();
            }
            //if the user is not login
            else {
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}

// Admin account
// Username: admin@gmail.com
// Password: admin123
