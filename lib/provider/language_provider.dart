import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class LanguageProvider extends ChangeNotifier {
  TextRecognitionScript _script = TextRecognitionScript.chinese;

  TextRecognitionScript get script => _script;

  set script(TextRecognitionScript script) {
    _script = script;
    print('LanguageProvider: set script: $_script');
    notifyListeners();
  }
}
