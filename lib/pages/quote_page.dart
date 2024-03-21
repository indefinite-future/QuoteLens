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

    //print('Number of books: ${booksSnapshot.docs.length}');

    List<Map<String, dynamic>> items = [];

    for (final bookDoc in booksSnapshot.docs) {
      //print('Book ID: ${bookDoc.id}');
      //print('Author: ${bookDoc.get('author')}');

      final quotesSnapshot = await bookDoc.reference.collection('quotes').get();

      //print('Number of quotes in book ${bookDoc.id}: ${quotesSnapshot.docs.length}');

      final quotes =
          quotesSnapshot.docs.map((quoteDoc) => quoteDoc.get('quote')).toList();

      for (final quote in quotes) {
        items.add({
          'bookName': bookDoc.get('bookName'),
          'author': bookDoc.get('author'),
          'quote': quote,
        });
      }
    }

    yield items;
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
                        return Container(
                          width: 400,
                          height: 150,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          padding: const EdgeInsets.all(10), // Add padding here
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
