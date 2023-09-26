import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fypv2/components/login_squarebox.dart';
import 'package:fypv2/components/login_textfield.dart';
import '../components/login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthMultiFactorException catch (e) {
      print(e.message);
      print(e.code);
      rethrow;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print('Firebase Authentication Exception: ${e.message}');
      if (e.code == 'user-not-found' || e.code == 'invalid-email') {
        wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else if (e.code == 'invalid-login-credentials') {
        print('invalid-login-credentials');
      }
    } on PlatformException catch (e) {
      Navigator.pop(context);
      print('Platform Exception: ${e.message}');
    } catch (e) {
      Navigator.pop(context);
      print('Exception: ${e.toString()}');
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Wrong email'),
            content: const Text('Please enter a valid email address'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'))
            ],
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Wrong password'),
            content: const Text('Please enter a valid password'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
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
                          controller: emailController,
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

                      LoginButton(
                        onTap: signUserIn,
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
