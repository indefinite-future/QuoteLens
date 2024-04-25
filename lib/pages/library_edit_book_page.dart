import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditBookPage extends StatefulWidget {
  final String bookId;

  const EditBookPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _bookNameController = TextEditingController();
  final _authorController = TextEditingController();
  final _publisherController = TextEditingController();
  final _yearController = TextEditingController();

  FocusNode _bookNameFocusNode = FocusNode();
  FocusNode _authorFocusNode = FocusNode();
  FocusNode _publisherFocusNode = FocusNode();
  FocusNode _yearFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _bookNameFocusNode.addListener(() {
      setState(() {});
    });
    _authorFocusNode.addListener(() {
      setState(() {});
    });
    _publisherFocusNode.addListener(() {
      setState(() {});
    });
    _yearFocusNode.addListener(() {
      setState(() {});
    });
    fetchBookDetails();
  }

  fetchBookDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final bookRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('books')
        .doc(widget.bookId);

    final bookSnapshot = await bookRef.get();

    setState(() {
      _bookNameController.text = bookSnapshot['bookName'];
      _authorController.text = bookSnapshot['author'];
      _publisherController.text = bookSnapshot['publisher'];
      _yearController.text = bookSnapshot['year'].toString();
    });
  }

  @override
  void dispose() {
    _bookNameFocusNode.dispose();
    _authorFocusNode.dispose();
    _publisherFocusNode.dispose();
    _yearFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Book'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 100),
                  Icon(
                    FeatherIcons.book,
                    size: 180,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    focusNode: _bookNameFocusNode,
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      labelText: 'Book Title',
                      labelStyle: TextStyle(
                        color: _bookNameFocusNode.hasFocus
                            ? Colors.cyan
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a book title.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _authorFocusNode,
                    controller: _authorController,
                    decoration: InputDecoration(
                      labelText: 'Author',
                      labelStyle: TextStyle(
                        color: _authorFocusNode.hasFocus
                            ? Colors.cyan
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an author.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    focusNode: _publisherFocusNode,
                    controller: _publisherController,
                    decoration: InputDecoration(
                      labelText: 'Publisher',
                      labelStyle: TextStyle(
                        color: _publisherFocusNode.hasFocus
                            ? Colors.cyan
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  TextFormField(
                    focusNode: _yearFocusNode,
                    controller: _yearController,
                    decoration: InputDecoration(
                      labelText: 'Year',
                      labelStyle: TextStyle(
                        color: _yearFocusNode.hasFocus
                            ? Colors.cyan
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final user = FirebaseAuth.instance.currentUser;
                          final bookRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('books')
                              .doc(widget.bookId);

                          int? year;
                          if (_yearController.text.isNotEmpty &&
                              !_yearController.text.contains(RegExp(r'\D'))) {
                            year = int.parse(_yearController.text);
                          }

                          await bookRef.update({
                            'bookName': _bookNameController.text,
                            'author': _authorController.text,
                            'publisher': _publisherController.text,
                            'year': year,
                          });

                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
