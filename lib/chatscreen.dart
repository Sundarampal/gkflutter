import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final fromCtrl = TextEditingController();
  final toCtrl = TextEditingController();
  final textCtrl = TextEditingController();

  // 🔹 JSON DATA
  Map<String, dynamic> jsonData = {
    "messages": [
      {"from": "A", "to": "B", "text": "Hello"},
      {"from": "B", "to": "A", "text": "Hi"},
      {"from": "B", "to": "A", "text": "Ok"},
    ]
  };

  bool loading = true;
  String info = "";

  // 🔹 LOAD JSON FROM API
  Future<void> loadJson() async {
    try {
      final res = await http.get(
        Uri.parse(
          "https://sundarampal.github.io/myjsonfiles/chatbox.json",
        ),
      );

      if (res.statusCode == 200 && res.body.trim().startsWith("{")) {
        final decoded = jsonDecode(res.body);

        if (decoded["messages"] is List) {
          setState(() {
            jsonData = decoded;
            info = "Loaded from API";
          });
        }
      } else {
        info = "API invalid → Local JSON";
      }
    } catch (e) {
      info = "Error → Local JSON";
    }

    setState(() {
      loading = false;
    });
  }

  // 🔹 ADD MESSAGE TO JSON
  void addMessage() {
    if (fromCtrl.text.isEmpty ||
        toCtrl.text.isEmpty ||
        textCtrl.text.isEmpty) return;

    setState(() {
      (jsonData["messages"] as List).add({
        "from": fromCtrl.text,
        "to": toCtrl.text,
        "text": textCtrl.text,
      });
    });

    fromCtrl.clear();
    toCtrl.clear();
    textCtrl.clear();
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    final List messages = jsonData["messages"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Messages"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 INPUT AREA
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                input(fromCtrl, "From"),
                input(toCtrl, "To"),
                input(textCtrl, "Message"),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: addMessage,
                    child: const Text("Add Message"),
                  ),
                ),
              ],
            ),
          ),

          Text(
            info,
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Divider(),

          // 🔹 MESSAGE LIST
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          "From: ${msg["from"]}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("To: ${msg["to"]}"),
                        const SizedBox(height: 6),
                        Text(
                          msg["text"],
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 INPUT FIELD
  Widget input(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
