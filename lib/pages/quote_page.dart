import 'package:flutter/material.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
//   Future<List<DocumentSnapshot>> getQuotes() async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) {
//     throw Exception('Must be logged in to get quotes');
//   }

//   final bookRef = FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .collection('books')
//       .doc(widget.bookName);

//   final QuerySnapshot querySnapshot = await bookRef.collection('quotes').get();

//   return querySnapshot.docs;
// }

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      child: Center(
        child: Text('Quote Screen'),
      ),
    );
  }
}
