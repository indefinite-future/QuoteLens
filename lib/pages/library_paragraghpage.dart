import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BookParagraphPage extends StatefulWidget {
  final String bookName;
  const BookParagraphPage({super.key, required this.bookName});

  @override
  State<BookParagraphPage> createState() => _BookParagraphPageState();
}

class _BookParagraphPageState extends State<BookParagraphPage> {
  Future<String> getBookName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in.');
      return 'No title';
    }
    //print('Fetching book name for ${widget.bookName}...');
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .where('bookName', isEqualTo: widget.bookName)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      Map<String, dynamic>? data =
          querySnapshot.docs.first.data() as Map<String, dynamic>?;
      //print('Book name: ${data!['bookName']}');
      return data != null ? data['bookName'] : 'No title';
    } else {
      print('Query snapshot is empty.');
      return 'No title';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getBookName(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text('${snapshot.data}'),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: SafeArea(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Click the bottom button to start.'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ),
                // );
              },
              backgroundColor: Colors.cyan,
              child: const Icon(Icons.add),
            ),
          );
        }
      },
    );
  }
}
