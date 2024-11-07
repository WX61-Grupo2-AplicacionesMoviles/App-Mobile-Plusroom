import 'package:flutter/material.dart';

class TextItem extends StatelessWidget {
  final String title;
  final double titleSize;
  final String text;
  final double textSize;

  const TextItem({
    super.key,
    required this.title,
    required this.titleSize,
    required this.text,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}

