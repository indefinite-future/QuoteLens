import 'package:QuoteLens/pages/library_paragraghpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:QuoteLens/pages/library_add_book_page.dart';
import 'package:firebase_core/firebase_core.dart';

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
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Column(
                        children: [
                          SizedBox(height: 300),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No books is added,\n click the bottom right button to \n start adding books now!',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyan,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      var books = snapshot.data!.docs.toList();

                      // Sort the books based on the 'last_click' timestamp in descending order
                      books.sort(
                          (a, b) => b['last_click'].compareTo(a['last_click']));

                      var latestBook = books.first;
                      final user = FirebaseAuth.instance.currentUser;

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
                            onLongPress: () => showDialog<String>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AlertDialog.adaptive(
                                backgroundColor:
                                    const Color.fromRGBO(142, 142, 147, 1),
                                title: const Text('Delete Book'),
                                content: const Text(
                                  'Are you sure you want to delete this book?',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel',
                                        style: TextStyle(color: Colors.cyan)),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      // Delete the book from the database
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user!.uid)
                                          .collection('books')
                                          .doc(latestBook.id)
                                          .delete();

                                      // try {
                                      //   // Delete the book from the storage
                                      //   await widget.storageRef
                                      //       .child(user.uid)
                                      //       .child(latestBook.id)
                                      //       .delete();
                                      // } catch (e) {
                                      //   if (e is FirebaseException &&
                                      //       e.code == 'object-not-found') {
                                      //     print(
                                      //         'The book was not found in the storage.');
                                      //   } else {
                                      //     rethrow;
                                      //   }
                                      // }

                                      // Update the latest clicked book
                                      var books = snapshot.data!.docs.toList();
                                      books.sort((a, b) => b['last_click']
                                          .compareTo(a['last_click']));
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.uid)
                                          .update({
                                        'latestClickedBook': latestBook.id
                                      });

                                      Navigator.pop(context, 'OK');
                                    },
                                    child: const Text('OK',
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            ),
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
                                  onLongPress: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog.adaptive(
                                      backgroundColor: const Color.fromRGBO(
                                          142, 142, 147, 1),
                                      title: const Text('Delete Book'),
                                      content: const Text(
                                        'Are you sure you want to delete this book?',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel',
                                              style: TextStyle(
                                                  color: Colors.cyan)),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Delete the book from the database
                                            await FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(user!.uid)
                                                .collection('books')
                                                .doc(book.id)
                                                .delete();

                                            // try {
                                            //   // Delete the book from the storage
                                            //   await widget.storageRef
                                            //       .child(user.uid)
                                            //       .child(book.id)
                                            //       .delete();
                                            // } catch (e) {
                                            //   if (e is FirebaseException &&
                                            //       e.code ==
                                            //           'object-not-found') {
                                            //     print(
                                            //         'The book was not found in the storage.');
                                            //   } else {
                                            //     rethrow;
                                            //   }
                                            // }

                                            // Update the latest clicked book
                                            // var books =
                                            //     snapshot.data!.docs.toList();
                                            // books.sort((a, b) => b['last_click']
                                            //     .compareTo(a['last_click']));
                                            // await FirebaseFirestore.instance
                                            //     .collection('users')
                                            //     .doc(user.uid)
                                            //     .update({
                                            //   'latestClickedBook': latestBook.id
                                            // });

                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK',
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                      ],
                                    ),
                                  ),
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
