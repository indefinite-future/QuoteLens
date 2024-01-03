import 'package:QuoteLens/pages/library_page.dart';
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

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // Future addUserDetails(String email, String username) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'email': email,
  //     'username': username,
  //     'created_at': DateTime.now(),
  //     'last_login': DateTime.now(),
  //     'pofile_pic': '/images/default_profile_pic.png',
  //   });
  // }

  Future<void> addUserDetails(String email, String username) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return users
        .doc(uid)
        .set({
          'uid': uid,
          'email': email,
          'username': username,
          'created_at': DateTime.now(),
          'last_login': DateTime.now(),
          'profile_pic': '/images/default_profile_pic.png',
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

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
      // get email and username from controllers
      String email = emailController.text;
      String password = passwordController.text;

      // Check if the email is already registered
      var users = FirebaseFirestore.instance.collection('users');
      var doc = await users.where('email', isEqualTo: email).get();
      if (doc.size > 0) {
        // The email is already registered
        print("The email is already registered.");
        Navigator.pop(context);
        emailAlreadyInUse();
        return;
      }

      // Check if the password matches
      String confirmPassword = confirmPasswordController.text;
      if (password != confirmPassword) {
        // The password does not match
        print("The password does not match.");
        Navigator.pop(context);
        passwordNotMatch();
        return;
      }

      Navigator.pop(context);

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: unused_local_variable
      String uid = userCredential.user!.uid;
      String username = email; // or get username from user input if necessary
      await addUserDetails(email, username);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        weakPassword();
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        wrongInputMessage();
      }
      // for debugging purposes
      print('\n Firebase Authentication Exception: ${e.message} \n');
      print('Firebase Authentication Exception Code: ${e.code}');
    } catch (e) {
      print('Exception: ${e.toString()}');
    } finally {
      Navigator.pop(context);
    }
  }

  void emailAlreadyInUse() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            backgroundColor: const Color.fromRGBO(142, 142, 147, 1),
            title: const Text('Register Failed'),
            content: const Text(
              'The email address is already in use by another account.',
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
                    obscureText: false,
                    prefixIcon: const Icon(Icons.email_rounded),
                  ),

                  const SizedBox(height: 20),

                  // Password text field
                  LoginTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_rounded)),

                  const SizedBox(height: 20),

                  // Password confirm text field
                  LoginTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.lock_rounded),
                  ),

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
                                color: Theme.of(context).colorScheme.tertiary,
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
                          onTap: () => AuthService().signInWithGoogle,
                          imagepath: 'lib/images/google.png'),

                      const SizedBox(width: 25),

                      // Apple button
                      SquareTile(
                          onTap: () => {}, imagepath: 'lib/images/apple.png'),
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
