
import 'package:app_mobile_plusroom/properties-searching/search-page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF064789), // Color del tema principal
        ),
        useMaterial3: true,
      ),
      home: const PropertiesPage(),
    );
  }
}


