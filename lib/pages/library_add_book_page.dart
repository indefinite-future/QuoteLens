import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:feather_icons/feather_icons.dart';

class AddBooksPage extends StatefulWidget {
  const AddBooksPage({super.key});

  @override
  State<AddBooksPage> createState() => _AddBooksPageState();
}

class _AddBooksPageState extends State<AddBooksPage> {
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
        title: const Text('Add New Books'),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
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
                      label: Row(
                        children: [
                          Text(
                            "Book Title",
                            style: TextStyle(
                              color: _bookNameFocusNode.hasFocus
                                  ? Colors.cyan
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3.0),
                          ),
                          const Text('*', style: TextStyle(color: Colors.red)),
                        ],
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
                      label: Row(
                        children: [
                          Text(
                            "Author",
                            style: TextStyle(
                              color: _authorFocusNode.hasFocus
                                  ? Colors.cyan
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(3.0),
                          ),
                          const Text('*', style: TextStyle(color: Colors.red)),
                        ],
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
                          // If the form is valid, add the book to Firestore
                          final user = FirebaseAuth.instance.currentUser;
                          final bookRef = FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('books')
                              .doc();

                          int? year;
                          if (_yearController.text.isNotEmpty &&
                              !_yearController.text.contains(RegExp(r'\D'))) {
                            year = int.parse(_yearController.text);
                          }

                          await bookRef.set({
                            'bookId': bookRef.id,
                            'bookName': _bookNameController.text,
                            'author': _authorController.text,
                            'publisher': _publisherController.text,
                            'year': year,
                            'last_click': Timestamp.now(),
                          });

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.uid)
                              .update(
                            {'latestClickedBook': bookRef.id},
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Submit',
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
