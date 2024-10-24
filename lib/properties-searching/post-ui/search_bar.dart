// post-ui/search_bar.dart
import 'package:flutter/material.dart';

class SearchBarSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const SearchBarSection({
    super.key,
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.grey[200],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Enter a location',
                  hintStyle: TextStyle(color: Color(0xFF064789)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search, color: Color(0xFF064789)),
              onPressed: onSearch,
            ),
          ],
        ),
      ),
    );
  }
}
