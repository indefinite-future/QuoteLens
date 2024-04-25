import 'package:QuoteLens/pages/library_manual_input.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/search_bar.dart' as search_bar;

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  String searchQuery = '';
  Stream<List<Map<String, dynamic>>> getQuotes() async* {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Must be logged in to get quotes');
    }

    final booksRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('books');

    final booksSnapshot = await booksRef.get();

    List<Map<String, dynamic>> items = [];

    for (final bookDoc in booksSnapshot.docs) {
      final quotesSnapshot = await bookDoc.reference.collection('quotes').get();

      for (final quoteDoc in quotesSnapshot.docs) {
        items.add({
          'bookName': bookDoc.get('bookName'),
          'author': bookDoc.get('author'),
          'quote': quoteDoc.get('quote'),
          'quoteId': quoteDoc.id, // Add this line
        });
      }
    }

    yield items;
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            search_bar.SearchBar(
              onSearch: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getQuotes(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  return ListView.builder(
                    shrinkWrap: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];

                      if (searchQuery.isEmpty ||
                          item['bookName']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase()) ||
                          item['quote']
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuillEditorPage(
                                  bookName: item['bookName'],
                                  quoteId:
                                      item['quoteId'], // Pass the quoteId here
                                  quoteText:
                                      item['quote'], // pass the quote text
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
                                        color: Theme.of(context).primaryColor,
                                      )),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteQuoteFromFirebase(
                                            item['bookName'],
                                            item[
                                                'quoteId']); // Pass the quoteId here
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Delete',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 400,
                            height: 150,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            padding:
                                const EdgeInsets.all(10), // Add padding here
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.transparent),
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['bookName'],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      //fontWeight: FontWeight.bold,
                                    )),
                                Text(item['author'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      //fontStyle: FontStyle.italic,
                                    )),
                                const Divider(color: Colors.grey),
                                Text(
                                  item['quote'],
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
