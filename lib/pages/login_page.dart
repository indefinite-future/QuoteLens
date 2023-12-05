import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:QuoteLens/components/login_squarebox.dart';
import 'package:QuoteLens/components/login_textfield.dart';
import 'package:QuoteLens/components/login_button.dart';
import 'package:QuoteLens/services/auth_services.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  // sign in user
  // if successful, navigate to home page
  // else, show error message
  void signUserIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    // try signing in user
    try {
      // get email and password from controllers
      String email = emailController.text;
      String password = passwordController.text;

      // Sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      Navigator.pop(context);

      // Update last_login field
      var users = FirebaseFirestore.instance.collection('users');
      var doc = await users.where('email', isEqualTo: email).get();
      if (doc.size > 0) {
        await users.doc(doc.docs[0].id).update({'last_login': DateTime.now()});
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        netwrokProblem();
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        wrongInputMessage();
      }
      // for debugging purposes
      print('\n Firebase Authentication Exception: ${e.message} \n');
      print('Firebase Authentication Exception Code: ${e.code}');
    } catch (e) {
      print('Exception: ${e.toString()}');
    } finally {
      if (mounted && Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void netwrokProblem() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: const Color.fromRGBO(142, 142, 147, 1),
            title: const Text('Network request failed'),
            content: const Text(
              'Please wait and try again.',
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
                      const SizedBox(height: 80),

                      // Lock icon
                      const Icon(Icons.lock_person_rounded, size: 150),

                      const SizedBox(height: 30),

                      // Welcome text
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 26,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Username text field
                      LoginTextField(
                        controller: emailController,
                        hintText: 'Username',
                        obscureText: false,
                        prefixIcon: const Icon(
                          Icons.email_rounded,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Password text field
                      LoginTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_rounded),
                      ),

                      const SizedBox(height: 8),

                      // Forgot password text
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 50.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Forgot password?',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          )),

                      const SizedBox(height: 20),

                      // Sign in button
                      LoginButton(
                        onTap: signUserIn,
                        text: 'Sign In',
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
                          Text('Not a member?',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor)),
                          const SizedBox(width: 5),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: const Text(
                              'Register Now',
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
