import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserScreen extends StatefulWidget {
  UserScreen({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  //sign out function
  void signUserOut() async {
    // sign out user
    // if successful, navigate to login page
    // else, show error message
    await FirebaseAuth.instance.signOut();
  }

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
          ],
        ),
      ),
    );
  }
}
