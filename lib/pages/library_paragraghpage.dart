import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BookParagraphPage extends StatefulWidget {
  final String bookId;
  const BookParagraphPage({super.key, required this.bookId});

  @override
  State<BookParagraphPage> createState() => _BookParagraphPageState();
}

class _BookParagraphPageState extends State<BookParagraphPage> {
  Future<String> getBookName() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('books')
        .doc(widget.bookId)
        .get();
    Map<String, dynamic>? data =
        documentSnapshot.data() as Map<String, dynamic>?;
    return data != null ? data['title'] : 'No title';
  }

  @override
  Widget build(BuildContext context) {
    Future<String> bookName = getBookName();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Book Paragraph Page Screen'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
