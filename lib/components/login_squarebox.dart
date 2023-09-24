import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final String imagepath;

  const SquareTile({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Image.asset(
        imagepath,
        height: 40,
      ),
    );
  }
}
