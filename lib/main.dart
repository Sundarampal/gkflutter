import 'package:flutter/material.dart';
import 'package:gkflutter/utilities.dart';

void main() {

  Future<void>loadData() async {
    try {
      final data = await Utilities.downloadJson(
        "https://sundarampal.github.io/myjsonfiles/chatbox.json",
      );

    } catch (e) {
      print("hii");
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}
