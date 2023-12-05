import 'package:QuoteLens/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  //user profile picture
                  FutureBuilder(
                    future: FirebaseStorage.instance
                        .ref()
                        .child('images/${widget.user.uid}/profile_pic.png')
                        .getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CircleAvatar(
                          radius: 100,
                          backgroundImage:
                              NetworkImage(snapshot.data.toString()),
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 100,
                          backgroundImage:
                              AssetImage('lib/images/default_profile_pic.png'),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  //user email
                  Text(
                    widget.user.email!,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  //logout button
                  ElevatedButton(
                    child: Text('Logout',
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      widget.signUserOut();
                    },
                  ),

                  const SizedBox(height: 30),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: SwitchListTile(
                      title: const Text('Toggle Theme'),
                      value: Provider.of<ThemeProvider>(context).isDarkModeOn,
                      onChanged: (bool value) {
                        Provider.of<ThemeProvider>(context, listen: false)
                            .toggleTheme();
                      },
                      secondary: const Icon(Icons.lightbulb_outline),
                    ),
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
