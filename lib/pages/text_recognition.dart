import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class TextRecognizerPage extends StatefulWidget {
  const TextRecognizerPage({super.key});

  @override
  State<TextRecognizerPage> createState() => _TextRecognizerPageState();
}

class _TextRecognizerPageState extends State<TextRecognizerPage> {
  CameraController? controller;
  String recognizedText = '';

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    await controller!.initialize();
  }

  Future<void> recognizeText() async {
    final path = await takePicture();
    final inputImage = InputImage.fromFilePath(path);
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(inputImage);
    setState(() {
      this.recognizedText = recognizedText.text;
    });
  }

  Future<String> takePicture() async {
    if (!controller!.value.isInitialized) {
      print('Error: select a camera first.');
      return '';
    }
    if (controller!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return '';
    }
    try {
      final image = await controller!.takePicture();
      return image.path;
    } catch (e) {
      print(e);
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          if (controller != null && controller!.value.isInitialized)
            CameraPreview(controller!),
          TextButton(
            child: Text('Recognize Text'),
            onPressed: recognizeText,
          ),
          Text(recognizedText),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
