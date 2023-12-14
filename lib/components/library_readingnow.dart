// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class ReadingNow extends StatefulWidget {
//   const ReadingNow({super.key});

//   @override
//   _ReadingNowState createState() => _ReadingNowState();
// }

// class _ReadingNowState extends State<ReadingNow> {
//   late Future<DocumentSnapshot> latestBook;

//   @override
//   void initState() {
//     super.initState();
//     latestBook = getLatestClickedBook();
//   }

//   Future<DocumentSnapshot> getLatestClickedBook() async {
//     final user = FirebaseAuth.instance.currentUser;
//     DocumentSnapshot userDoc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(user!.uid)
//         .get();
//     String latestBookId = userDoc['latestClickedBook'];

//     return FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('books')
//         .doc(latestBookId)
//         .get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 400,
//       height: 150,
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       padding: const EdgeInsets.all(20.0),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.transparent),
//         color: Theme.of(context).colorScheme.primary,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
//         children: [
//           const Row(),
//           const Text(
//             'Reading Now',
//             style: TextStyle(fontSize: 20),
//             textAlign: TextAlign.start,
//           ),
//           const SizedBox(height: 5),
//           const Divider(
//             thickness: 0.5,
//             color: Colors.grey,
//           ),
//           const SizedBox(height: 5),
//           FutureBuilder<DocumentSnapshot>(
//             future: getLatestClickedBook(),
//             builder: (BuildContext context,
//                 AsyncSnapshot<DocumentSnapshot> snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 if (snapshot.data!.exists) {
//                   return Row(
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             snapshot.data!['bookName'],
//                             style: const TextStyle(fontSize: 20),
//                             textAlign: TextAlign.left,
//                           ),
//                           Text(
//                             snapshot.data!['author'],
//                             style: const TextStyle(fontSize: 15),
//                             textAlign: TextAlign.left,
//                           ),
//                         ],
//                       ),
//                     ],
//                   );
//                 } else {
//                   return const Text(
//                     'Go add a book first!',
//                     style: TextStyle(fontSize: 25),
//                     textAlign: TextAlign.center,
//                   );
//                 }
//               }
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
