import 'package:flutter/material.dart';

class ReadingNow extends StatelessWidget {
  const ReadingNow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 400,
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Align text to the left
            children: [
              const Row(),
              const Text(
                'Reading Now',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 5),
              const Divider(
                thickness: 0.5,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The Alchemist',
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        'Paulo Coelho',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),

                  // Book cover
                  const SizedBox(width: 50),

                  Container(
                    width: 150,
                    height: 190,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/100'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              )
            ]));
  }
}
