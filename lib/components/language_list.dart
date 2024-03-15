import 'package:QuoteLens/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:provider/provider.dart';

class LanguageList extends StatefulWidget {
  final TextRecognitionScript initialScript;
  final ValueChanged<TextRecognitionScript> onScriptChanged;

  const LanguageList({
    required this.initialScript,
    required this.onScriptChanged,
    super.key,
  });

  @override
  State<LanguageList> createState() => _LanguageListState();
}

class _LanguageListState extends State<LanguageList> {
  late TextRecognitionScript _script;

  @override
  void initState() {
    super.initState();
    _script = widget.initialScript;
  }

  String getDisplayName(TextRecognitionScript script) {
    switch (script) {
      case TextRecognitionScript.latin:
        return 'English';
      case TextRecognitionScript.chinese:
        return '中文';
      default:
        return script.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return ListTile(
      title: const Text('Text Recognition Language'),
      subtitle: Text(getDisplayName(languageProvider.script)),
      trailing: const Icon(Icons.language),
      textColor: Theme.of(context).primaryColor,
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
              child: Wrap(
                children: TextRecognitionScript.values.map<Widget>((script) {
                  return ListTile(
                    title: Text(getDisplayName(script)),
                    onTap: () {
                      languageProvider.script = script;
                      widget.onScriptChanged(script);
                      print('change script from UI: $script');
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }
}






// class LanguageList extends StatefulWidget {
//   final TextRecognitionScript initialScript;
//   final ValueChanged<TextRecognitionScript> onScriptChanged;

//   const LanguageList({
//     required this.initialScript,
//     required this.onScriptChanged,
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<LanguageList> createState() => _LanguageListState();
// }

// class _LanguageListState extends State<LanguageList> {
//   late TextRecognitionScript _script;

//   @override
//   void initState() {
//     super.initState();
//     _script = widget.initialScript;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton<TextRecognitionScript>(
//       value: _script,
//       icon: const Icon(Icons.arrow_downward),
//       elevation: 16,
//       style: const TextStyle(color: Colors.blue),
//       underline: Container(
//         height: 2,
//         color: Colors.blue,
//       ),
//       onChanged: (TextRecognitionScript? script) {
//         if (script != null) {
//           setState(() {
//             _script = script;
//           });
//           widget.onScriptChanged(script);
//         }
//       },
//       items: TextRecognitionScript.values
//           .map<DropdownMenuItem<TextRecognitionScript>>((script) {
//         return DropdownMenuItem<TextRecognitionScript>(
//           value: script,
//           child: Text(script.name),
//         );
//       }).toList(),
//     );
//   }
// }
