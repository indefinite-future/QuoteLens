import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:QuoteLens/components/login_squarebox.dart';
import 'package:QuoteLens/components/login_textfield.dart';
import 'package:QuoteLens/components/login_button.dart';
import 'package:QuoteLens/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  Future addUserDetails(String email, String username) async {
    await FirebaseFirestore.instance.collection('users').add({
      'email': email,
      'username': username,
      'created_at': DateTime.now(),
      'last_login': DateTime.now(),
      'pofile_pic': '/images/default_profile_pic.png',
    });
  }

  // sign in user
  // if successful, navigate to home page
  // else, show error message
  Future signUserUp() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try signing up user
    try {
      // check if passwords match
      if (confirmPasswordController.text == passwordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        addUserDetails(
          emailController.text,
          emailController.text,
        );
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        weakPassword();
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        wrongInputMessage();
      }
      // for debugging purposes
      print('\n Firebase Authentication Exception: ${e.message} \n');
      print('Firebase Authentication Exception Code: ${e.code}');
    } catch (e) {
      Navigator.pop(context);
      print('Exception: ${e.toString()}');
    }
  }

  void passwordNotMatch() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: const Color.fromRGBO(142, 142, 147, 1),
            title: const Text('Create account failed'),
            content: const Text(
              'Please match the password.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )))
            ],
          );
        });
  }

  void weakPassword() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: const Color.fromRGBO(142, 142, 147, 1),
            title: const Text('Register Failed'),
            content: const Text(
              'Password should be at least 6 characters.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )))
            ],
          );
        });
  }

  void wrongInputMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: const Color.fromRGBO(142, 142, 147, 1),
            title: const Text('Wrong email or password'),
            content: const Text(
              'Please enter a valid email address or password',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      )))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
          child: SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),

                      // Lock icon
                      const Icon(Icons.lock_person_rounded, size: 150),

                      const SizedBox(height: 30),

                      // Welcome text
                      const Text(
                        'Let\'s get started!',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Username text field
                      LoginTextField(
                          controller: emailController,
                          hintText: 'Username',
                          obscureText: false),

                      const SizedBox(height: 20),

                      // Password text field
                      LoginTextField(
                          controller: passwordController,
                          hintText: 'Password',
                          obscureText: true),

                      const SizedBox(height: 20),

                      // Password confirm text field
                      LoginTextField(
                          controller: confirmPasswordController,
                          hintText: 'Confirm Password',
                          obscureText: true),

                      const SizedBox(height: 8),

                      // Forgot password text
                      // const Padding(
                      //     padding: EdgeInsets.symmetric(horizontal: 50.0),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.end,
                      //       children: [
                      //         Text(
                      //           'Forgot password?',
                      //           style: TextStyle(
                      //             fontSize: 14,
                      //             color: Colors.white,
                      //           ),
                      //         ),
                      //       ],
                      //     )),

                      const SizedBox(height: 20),

                      // Sign up button
                      LoginButton(
                        onTap: signUserUp,
                        text: 'Sign Up',
                      ),

                      const SizedBox(height: 25),

                      // Or continue with
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      thickness: 0.5, color: Colors.grey[400])),
                              Text("   Or continue with   ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  )),
                              Expanded(
                                  child: Divider(
                                      thickness: 0.5, color: Colors.grey[400])),
                            ],
                          )),

                      const SizedBox(height: 25),

                      // Google and Apple buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google button
                          SquareTile(
                              onTap: () => AuthService().signInWithGoogle(),
                              imagepath: 'lib/images/google.png'),

                          const SizedBox(width: 25),

                          // Apple button
                          SquareTile(
                              onTap: () => {},
                              imagepath: 'lib/images/apple.png'),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // Register text
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor)),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Login Now',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ))))),
    );
  }
}
