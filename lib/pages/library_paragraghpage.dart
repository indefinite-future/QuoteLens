import 'package:cloud_firestore/cloud_firestore.dart';
import 'text_detector_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'library_manual_input.dart';
import '../components/expandable_fab.dart';

class BookParagraphPage extends StatefulWidget {
  final String bookName;
  const BookParagraphPage({super.key, required this.bookName});

  @override
  State<BookParagraphPage> createState() => _BookParagraphPageState();
}

class _BookParagraphPageState extends State<BookParagraphPage> {
  //bool _showButtons = false;

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

  Future<String> getBookId(String bookName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is signed in.');
      return '';
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .where('bookName', isEqualTo: bookName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      print('No book found with the given name.');
      return '';
    }
  }

  Stream<List<DocumentSnapshot>> getQuotes(String bookId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Must be logged in to get quotes');
    }

    final quotesRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .doc(bookId)
        .collection('quotes')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.where((doc) {
        return doc.exists && doc.data().containsKey('quote');
      }).toList();
    });

    return quotesRef;
  }

  void deleteQuoteFromFirebase(String bookId, String quoteId) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Must be logged in to delete quotes');
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('books')
        .doc(bookId)
        .collection('quotes')
        .doc(quoteId)
        .delete()
        .then((_) {
      print("Quote successfully deleted!");
    }).catchError((error) {
      print("Failed to delete quote: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: getBookId(widget.bookName),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Loading...'),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
          );
        } else {
          return StreamBuilder<List<DocumentSnapshot>>(
            stream: getQuotes(snapshot.data!),
            builder: (BuildContext context,
                AsyncSnapshot<List<DocumentSnapshot>> quoteSnapshot) {
              if (quoteSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Loading quotes...'),
                    backgroundColor: Theme.of(context).colorScheme.background,
                  ),
                );
              } else {
                return Stack(
                  children: [
                    Scaffold(
                      backgroundColor: Theme.of(context).colorScheme.background,
                      appBar: AppBar(
                        title: Text('${widget.bookName}'),
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                      ),
                      body: ListView.builder(
                        shrinkWrap: true,
                        physics: quoteSnapshot.data!.length > 1
                            ? const ScrollPhysics()
                            : const NeverScrollableScrollPhysics(),
                        itemCount: quoteSnapshot.data!.length,
                        itemBuilder: (context, index) {
                          final quoteId = quoteSnapshot.data![index].id;
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
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuillEditorPage(
                                      bookName: widget.bookName,
                                      quoteId:
                                          quoteId, // replace with your actual quote id
                                      quoteText: quote, // pass the quote text
                                    ),
                                  ),
                                );
                              },
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog.adaptive(
                                      title: const Text('Delete quote?'),
                                      content: Text(
                                          'Are you sure you want to delete this quote?',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteQuoteFromFirebase(
                                                snapshot.data!, quoteId);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              )),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
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
                            ),
                          );
                        },
                      ),
                      floatingActionButton: ExpandableFab(
                        distance: 112.0,
                        children: [
                          ActionButton(
                            heroTag: 'manualInput',
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuillEditorPage(
                                    bookName: widget.bookName,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            icon: const Icon(Icons.keyboard),
                            tooltip: 'Manual input',
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).primaryColor,
                          ),
                          ActionButton(
                            heroTag: 'ocr',
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TextRecognizerView(
                                    bookName: widget.bookName,
                                  ),
                                ),
                              );
                              setState(() {});
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
