import 'package:flutter/material.dart';

class UserIcon extends StatelessWidget {
  final String iconPath;
  final double size;

  const UserIcon(
      {super.key,
      this.iconPath = 'assets/default_profile_pic.png',
      required this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundImage: AssetImage(iconPath),
    );
  }
}
