import 'package:flutter/material.dart';
import 'package:fypv2/components/library_readingnow.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        body: SafeArea(
            child: SingleChildScrollView(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(),
                    child: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          ReadingNow(),
                          SizedBox(height: 10),
                        ])))));
  }
}
