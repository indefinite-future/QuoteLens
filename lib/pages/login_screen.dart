import 'package:flutter/material.dart';
import 'package:fypv2/components/login_squarebox.dart';
import 'package:fypv2/components/login_textfield.dart';
import 'package:fypv2/pages/bottomnav.dart';
import 'package:fypv2/themes/themes.dart';
import '../components/login_button.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  // text editing controllers
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LibraryMain()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppsTheme.currentTheme.colorScheme.background,
      body: SafeArea(
          child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 110),

                      // Lock icon
                      const Icon(Icons.lock_person_rounded, size: 150),

                      const SizedBox(height: 30),

                      // Welcome text
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Username text field
                      LoginTextField(
                          controller: usernameController,
                          hintText: 'Username',
                          obscureText: false),

                      const SizedBox(height: 20),

                      // Password text field
                      LoginTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true),

                      const SizedBox(height: 8),

                      // Forgot password text
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )),

                      // Sign in button
                      const SizedBox(height: 20),

                      LoginButton(onTap: () => signUserIn(context)),

                      const SizedBox(height: 25),

                      // Or continue with
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      thickness: 0.5, color: Colors.grey[400])),
                              const Text("   Or continue with   ",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white)),
                              Expanded(
                                  child: Divider(
                                      thickness: 0.5, color: Colors.grey[400])),
                            ],
                          )),

                      const SizedBox(height: 25),

                      // Google and Apple buttons
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google button
                          SquareTile(imagepath: 'lib/images/google.png'),

                          SizedBox(width: 25),

                          // Apple button
                          SquareTile(imagepath: 'lib/images/apple.png'),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Register text
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Not a member?',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.white)),
                          SizedBox(width: 5),
                          Text('Register Now.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      )
                    ],
                  ))))),
    );
  }
}
