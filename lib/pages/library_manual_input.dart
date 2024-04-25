import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter/services.dart';
import 'package:appinio_social_share/appinio_social_share.dart';

class QuillEditorPage extends StatefulWidget {
  final String bookName;
  final String? quoteId;
  final String? quoteText;

  const QuillEditorPage(
      {super.key, required this.bookName, this.quoteId, this.quoteText});

  @override
  State<QuillEditorPage> createState() => _QuillEditorPageState();
}

class _QuillEditorPageState extends State<QuillEditorPage> {
  late QuillController _controller = QuillController.basic();
  late bool _readOnly = false;
  late bool _multiRowsDisplay = true;

  AppinioSocialShare appinioSocialShare = AppinioSocialShare();

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

    if (widget.quoteId != null) {
      // Update the existing quote
      final quoteRef = bookRef.collection('quotes').doc(widget.quoteId);
      await quoteRef.update({
        'quote': quote,
        'lastUpdatedAt': Timestamp.now(),
      });
    } else {
      // Create a new quote
      final quoteRef = bookRef.collection('quotes').doc();
      await quoteRef.set({
        'quote': quote,
        'createdAt': Timestamp.now(),
        'lastUpdatedAt': Timestamp.now(),
        'bookName': widget.bookName,
        'bookId': bookId,
      });
    }
  }

  void _toggleReadOnly() {
    setState(() {
      _readOnly = !_readOnly;
      _multiRowsDisplay = !_readOnly;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
    _controller.document.insert(0, widget.quoteText ?? '');
    _readOnly = widget.quoteId != null;
    _multiRowsDisplay = !_readOnly;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Editor'),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(
                  ClipboardData(text: _controller.document.toPlainText()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Quote copied to clipboard')),
              );
            },
          ),
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
              multiRowsDisplay: _multiRowsDisplay,
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
