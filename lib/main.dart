import 'package:app_mobile_plusroom/router/customRoutes.dart';
import 'package:app_mobile_plusroom/ui-initial-section/init_view.dart';
import 'package:app_mobile_plusroom/pages/roomie_search_page.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PlusRoom',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: InitView.id,
      routes: customRoutes,
      //home: RoomieSearch()
    );
  }
}


