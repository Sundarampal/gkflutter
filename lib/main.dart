import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SimplePage(),
    );
  }
}

class SimplePage extends StatelessWidget {
  const SimplePage({super.key});
Future<List<dynamic>> fetchjson() async {
  final response = await http.get (
    Uri.parse('')
  )
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Page"),
        centerTitle: true,
      ),
      body: Center(
        child:ElevatedButton(onPressed: (){}, child: const Text(
          "Hello Flutter ",
         ),
        ),
      ),

    );
  }
}
