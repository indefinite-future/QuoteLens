import 'package:cloud_firestore/cloud_firestore.dart';
import 'text_recognition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'library_manual_input.dart';
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
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text('${snapshot.data}'),
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Click the bottom button to start OCR.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(
                      () {
                        _showButtons = !_showButtons;
                      },
                    );
                  },
                  backgroundColor: Colors.cyan,
                  child: const Icon(Icons.add),
                ),
              ),
              if (_showButtons)
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            _showButtons = !_showButtons;
                          },
                        );
                      },
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 200,
                            child: FloatingActionButton(
                              heroTag: "ManualButton",
                              onPressed: () {
                                // Your code here
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const QuillEditorPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Manual input',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: 200,
                            child: FloatingActionButton(
                              heroTag: "OCRButton",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const TextRecognizerPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Using OCR',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          );
        }
      },
    );
  }
}
