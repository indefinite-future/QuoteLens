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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Books'),
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
                    controller: _bookNameController,
                    decoration:
                        const InputDecoration(labelText: 'Book Title *'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a book name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(labelText: 'Author *'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an author';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _publisherController,
                    decoration: const InputDecoration(labelText: 'Publisher'),
                    // No validator needed as this field is not required
                  ),
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(labelText: 'Year'),
                    // No validator needed as this field is not required
                  ),
                  const SizedBox(height: 50),
                  Container(
                    width: 200,
                    height: 50,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        side: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2),
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
