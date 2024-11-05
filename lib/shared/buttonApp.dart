
import 'package:flutter/material.dart';

Widget buttonApp(String text, Function onPressed){
  return TextButton(
      onPressed: (){
        onPressed();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(const Color(0xFFE7EFF6)),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
  );
}
