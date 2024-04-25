import 'dart:io';

import 'package:QuoteLens/components/language_list.dart';
import 'package:QuoteLens/pages/library_manual_input.dart';
import 'package:QuoteLens/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class GalleryView extends StatefulWidget {
  GalleryView(
      {Key? key,
      required this.title,
      required this.bookName,
      this.text,
      required this.onImage,
      required this.onDetectorViewModeChanged})
      : super(key: key);

  final String title;
  final String? text;
  final String bookName;
  final Function(InputImage inputImage) onImage;
  final Function()? onDetectorViewModeChanged;

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: widget.onDetectorViewModeChanged,
              child: Icon(
                Platform.isIOS ? Icons.camera_alt_outlined : Icons.camera,
              ),
            ),
          ),
        ],
      ),
      body: _galleryBody(),
    );
  }

  Widget _galleryBody() {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          _image != null
              ? SizedBox(
                  height: 450,
                  width: 450,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.file(_image!),
                    ],
                  ),
                )
              : const Icon(
                  Icons.image,
                  size: 200,
                ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
            child: LanguageList(
              initialScript: languageProvider.script,
              onScriptChanged: (script) {
                languageProvider.script = script;
              },
            ),
          ),
          if (widget.text != null && widget.text!.isNotEmpty)
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Text(
                'Recognized text:\n\n ${widget.text}',
              ),
            ),
          if (widget.text != null && widget.text!.isNotEmpty)
            Column(
              children: [
                ElevatedButton(
                  child: Text('Edit',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      )),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuillEditorPage(
                          quoteText: widget.text ??
                              '', // If widget.text is null, pass an empty string
                          bookName: widget
                              .bookName, // Replace this with your actual bookName
                        ),
                      ),
                    );
                  },
                ),
                const Divider(
                  thickness: 0.5,
                  color: Colors.grey,
                ),
              ],
            ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.gallery),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                foregroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor),
              ),
              child: Text(
                'From Gallery',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 0.0, horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () => _getImage(ImageSource.camera),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.cyan),
                // foregroundColor: MaterialStateProperty.all<Color>(
                //     Theme.of(context).primaryColor),
              ),
              child: Text(
                'Take a picture',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processFile(pickedFile.path);
    }
  }

  Future _processFile(String path) async {
    setState(() {
      _image = File(path);
    });
    _path = path;
    print('Image path: $_path');
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage);
  }
}
