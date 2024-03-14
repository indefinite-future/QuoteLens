import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillEditorPage extends StatefulWidget {
  final String bookName;
  const QuillEditorPage({super.key, required this.bookName});

  @override
  State<QuillEditorPage> createState() => _QuillEditorPageState();
}

class _QuillEditorPageState extends State<QuillEditorPage> {
  final QuillController _controller = QuillController.basic();
  bool _readOnly = false; // add this line

  Future<void> createQuote(String quote) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Must be logged in to create a quote');
    }

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final bookSnapshot = await userRef
        .collection('books')
        .where('bookName', isEqualTo: widget.bookName)
        .get();

    if (bookSnapshot.docs.isEmpty) {
      throw Exception('No book found with name: ${widget.bookName}');
    }

    final bookId = bookSnapshot.docs.first.id;
    final bookRef = userRef.collection('books').doc(bookId);

    final quoteRef = bookRef.collection('quotes').doc();

    await quoteRef.set({
      'quote': quote,
      'createdAt': Timestamp.now(),
      'lastUpdatedAt': Timestamp.now(),
      'bookName': widget.bookName,
    });
  }

  void _toggleReadOnly() {
    setState(() {
      _readOnly = !_readOnly;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Editor'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              String quote = _controller.document.toPlainText().trim();
              if (quote.isNotEmpty) {
                createQuote(quote);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cannot save an empty quote')),
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
              controller: _controller,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('en'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.background,
              padding: const EdgeInsets.all(16.0),
              child: QuillEditor.basic(
                configurations: QuillEditorConfigurations(
                  showCursor: true,
                  placeholder: 'Start writing your quote/ideas...',
                  controller: _controller,
                  readOnly: _readOnly,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('en'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        onPressed: _toggleReadOnly,
        child: Icon(_readOnly
            ? Icons.lock
            : Icons.lock_open), // change the icon based on _readOnly
      ),
    );
  }
}
