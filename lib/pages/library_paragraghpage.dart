import 'package:cloud_firestore/cloud_firestore.dart';
import 'text_detector_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'library_manual_input.dart';
import '../components/expandable_fab.dart';
//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class BookParagraphPage extends StatefulWidget {
  final String bookName;
  const BookParagraphPage({super.key, required this.bookName});

  @override
  State<BookParagraphPage> createState() => _BookParagraphPageState();
}

class _BookParagraphPageState extends State<BookParagraphPage> {
  bool _showButtons = false;

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

  Future<List<DocumentSnapshot>> getQuotes(String bookName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Must be logged in to get quotes');
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final bookSnapshot = await userRef
        .collection('books')
        .where('bookName', isEqualTo: bookName)
        .get();

    if (bookSnapshot.docs.isEmpty) {
      throw Exception('No book found with name: $bookName');
    }

    final bookId = bookSnapshot.docs.first.id;
    final bookRef = userRef.collection('books').doc(bookId);

    final QuerySnapshot quoteSnapshot =
        await bookRef.collection('quotes').get();

    return quoteSnapshot.docs;
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
          return FutureBuilder<List<DocumentSnapshot>>(
            future: getQuotes(snapshot.data!),
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> quoteSnapshot) {
              if (quoteSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Loading quotes...'),
                  ),
                );
              } else {
                return Stack(
                  children: [
                    Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      appBar: AppBar(
                        title: Text('${snapshot.data}'),
                      ),
                      body: ListView.builder(
                        shrinkWrap: true,
                        physics: quoteSnapshot.data!.length > 1
                            ? const ScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        itemCount: quoteSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          final quote = quoteSnapshot.data![index].get('quote');
                          return Container(
                            width: 400,
                            height: 60,
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
                                  quote,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      floatingActionButton: ExpandableFab(
                        distance: 112.0,
                        children: [
                          ActionButton(
                            heroTag: 'manualInput',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuillEditorPage(
                                    bookName: snapshot.data!,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.keyboard),
                            tooltip: 'Manual input',
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          ActionButton(
                            heroTag: 'ocr',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TextRecognizerView(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.camera),
                            tooltip: 'Using OCR',
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
