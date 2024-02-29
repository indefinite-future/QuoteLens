import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuillEditorPage extends StatefulWidget {
  const QuillEditorPage({super.key});

  @override
  State<QuillEditorPage> createState() => _QuillEditorPageState();
}

class _QuillEditorPageState extends State<QuillEditorPage> {
  late QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = QuillController.basic();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote Editor'),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: QuillEditor.basic(
        configurations: QuillEditorConfigurations(
          controller: _controller,
          readOnly: false,
          autoFocus: true,
          sharedConfigurations: const QuillSharedConfigurations(
            locale: Locale('zh', 'HK'),
          ),
        ),
      ),
    );
  }
}
