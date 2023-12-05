import 'package:QuoteLens/pages/library_paragraghpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:QuoteLens/components/library_readingnow.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:QuoteLens/pages/library_add_book_page.dart';

class LibraryPage extends StatefulWidget {
  LibraryPage({super.key});

  final storage = FirebaseStorage.instance;
  final storageRef = FirebaseStorage.instance.ref();

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  void updateLatestClickedBook(String bookId) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'latestClickedBook': bookId,
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookParagraphPage()),
                    );

                    // Update latest clicked book ID
                    // final user = FirebaseAuth.instance.currentUser;
                    // await FirebaseFirestore.instance
                    //     .collection('users')
                    //     .doc(user!.uid)
                    //     .update({'latestClickedBook': book.id});
                  },
                  child: const ReadingNow(),
                ),
                const Divider(
                  color: Colors.grey,
                  thickness: 1,
                  indent: 20,
                  endIndent: 20,
                ),
                const SizedBox(height: 10),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (userSnapshot.hasError) {
                      return Text('Error: ${userSnapshot.error}');
                    } else {
                      String latestBookId =
                          userSnapshot.data!['latestClickedBook'];
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .collection('books')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var books = snapshot.data!.docs
                                .where((book) => book.id != latestBookId)
                                .toList();

                            books.sort((a, b) =>
                                b['last_click'].compareTo(a['last_click']));

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: books.length > 1
                                  ? const ScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              itemCount: books.length,
                              itemBuilder: (context, index) {
                                var book = books[index];
                                return Container(
                                  width: 400,
                                  height: 80,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  //padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Text(book['bookName']),
                                    subtitle: Text(book['author']),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BookParagraphPage()),
                                      );
                                      // Handle book click
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .update({
                                        'latestClickedBook': book['bookId']
                                      });

                                      // Update last_click timestamp in books collection
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .collection('books')
                                          .doc(book['bookId'])
                                          .update(
                                              {'last_click': Timestamp.now()});
                                    },
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBooksPage()),
          );
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
    );
  }
}
