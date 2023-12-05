import 'package:flutter/material.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Widget prefixIcon;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText, //hide password
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide:
                //BorderSide(color: Theme.of(context).colorScheme.secondary),
                BorderSide(color: Colors.cyan),
          ),
          fillColor: Theme.of(context).colorScheme.background,
          filled: true,
          border: const OutlineInputBorder(),
          hintText: hintText,
        ),
      ),
    );
  }
}
