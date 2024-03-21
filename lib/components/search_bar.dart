import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const SearchBar({super.key, required this.onSearch});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        child: TextField(
          onChanged: (value) {
            setState(() {
              searchQuery = value;
            });
            widget.onSearch(value);
          },
          decoration: InputDecoration(
            labelText: 'Search keywords',
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            //suffixIcon: Icon(Icons.search),
            prefixIcon: const Icon(Icons.search),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
          ),
        ),
      ),
    );
  }
}
