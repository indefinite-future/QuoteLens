import 'package:QuoteLens/pages/library_paragraghpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('books')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      var books = snapshot.data!.docs.toList();

                      // Sort the books based on the 'last_click' timestamp in descending order
                      books.sort(
                          (a, b) => b['last_click'].compareTo(a['last_click']));

                      var latestBook = books.first;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookParagraphPage(
                                    bookName: latestBook['bookName'],
                                  ),
                                ),
                              );
                              final user = FirebaseAuth.instance.currentUser;
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .update({'latestClickedBook': latestBook.id});
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .collection('books')
                                  .doc(latestBook.id)
                                  .update({'last_click': Timestamp.now()});
                            },
                            child: Container(
                              width: 400,
                              height: 160,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              padding: const EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.transparent),
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align text to the left
                                children: [
                                  const Text(
                                    'Reading Now',
                                    style: TextStyle(fontSize: 24),
                                    textAlign: TextAlign.start,
                                  ),
                                  const SizedBox(height: 5),
                                  const Divider(
                                    thickness: 0.5,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    latestBook['bookName'],
                                    style: const TextStyle(fontSize: 20),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    latestBook['author'],
                                    style: const TextStyle(fontSize: 15),
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                            indent: 20,
                            endIndent: 20,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: books.length > 1
                                ? const ScrollPhysics()
                                : const NeverScrollableScrollPhysics(),
                            itemCount:
                                books.length - 1, // Exclude the latest book
                            itemBuilder: (context, index) {
                              // Start from the second book
                              var book = books[index + 1];
                              return Container(
                                width: 400,
                                height: 80,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.transparent),
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 3.0, bottom: 3.0),
                                    child: Text(
                                      book['bookName'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  subtitle: Text(
                                    book['author'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  onTap: () async {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookParagraphPage(
                                          bookName: book['bookName'],
                                        ),
                                      ),
                                    );
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user!.uid)
                                        .update({
                                      'latestClickedBook': book['bookId']
                                    });
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(user.uid)
                                        .collection('books')
                                        .doc(book['bookId'])
                                        .update(
                                            {'last_click': Timestamp.now()});
                                  },
                                ),
                              );
                            },
                          ),
                        ],
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
