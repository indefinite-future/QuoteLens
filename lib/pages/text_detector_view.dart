import 'package:QuoteLens/provider/language_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

import 'detector_view.dart';
import 'painters/text_detector_painter.dart';

class TextRecognizerView extends StatefulWidget {
  final String bookName;

  const TextRecognizerView({required this.bookName, super.key});

  @override
  State<TextRecognizerView> createState() => _TextRecognizerViewState();
}

class _TextRecognizerViewState extends State<TextRecognizerView> {
  var _script;
  var _textRecognizer;
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;
  var _cameraLensDirection = CameraLensDirection.back;

  @override
  void initState() {
    super.initState();
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    _script = languageProvider.script;
    _textRecognizer = TextRecognizer(script: _script);
  }

  @override
  void dispose() async {
    _canProcess = false;
    _textRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DetectorView(
            title: 'Text Detector',
            customPaint: _customPaint,
            text: _text,
            bookName: widget.bookName,
            onImage: _processImage,
            initialCameraLensDirection: _cameraLensDirection,
            onCameraLensDirectionChanged: (value) =>
                _cameraLensDirection = value,
          ),
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    _script = languageProvider.script;
    print('Processing image with script language: $_script');
    if (!_canProcess) {
      print('Cannot process image');
      return;
    }
    if (_isBusy) {
      print('Is busy');
      return;
    }
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final recognizedText = await _textRecognizer.processImage(inputImage);
    print('Recognized text: ${recognizedText.text}');
    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = TextRecognizerPainter(
        recognizedText,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = '${recognizedText.text}';
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
