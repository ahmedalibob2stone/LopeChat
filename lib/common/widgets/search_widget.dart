import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;

  const SearchWidget({
    Key? key,
    required this.query,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search contacts...',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
      onChanged: onChanged,
      controller: TextEditingController(text: query),
    );
  }
}
