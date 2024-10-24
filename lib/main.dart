import 'package:flutter/material.dart';
import 'package:app_mobile_plusroom/properties-searching/ui/post-ui/MakePost.dart'; // Asegúrate de ajustar el nombre de la ruta del archivo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MakePost(),
    );
  }
}
