import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const LoginButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          margin: const EdgeInsets.symmetric(horizontal: 50.0),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.background,
                    fontWeight: FontWeight.bold)),
          ),
        ));
  }
}
