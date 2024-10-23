
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buttonApp(String text, Function onPressed){
  return TextButton(
      onPressed: (){
        onPressed();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Color(0xFFE7EFF6)),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
  );
}
