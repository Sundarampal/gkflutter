import 'dart:convert';
import 'package:flutter/material.dart';
import 'utilities.dart';

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

  List<Map<String, dynamic>> messages = [];
  int index = 0;

  Future<void> loadJson() async {
    final data = await Utilities.downloadJson(
      'https://sundarampal.github.io/myjsonfiles/chatbox.json',
    );

    setState(() {
      messages = List<Map<String, dynamic>>.from(data['messages']);
      index = 0;
    });
  }

  void addMessage() {
    if (fromCtrl.text.isEmpty ||
        toCtrl.text.isEmpty ||
        textCtrl.text.isEmpty) return;

    setState(() {
      messages.add({
        "from": fromCtrl.text,
        "to": toCtrl.text,
        "text": textCtrl.text,
      });
      index = messages.length - 1;
    });

    textCtrl.clear();
  }

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: messages.isEmpty
            ? const Text("Loading...")
            : Text("Page ${index + 1}/${messages.length}"),
      ),
      body: Column(
        children: [
          /// INPUT
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                input(fromCtrl, "From"),
                input(toCtrl, "To"),
                input(textCtrl, "Text"),
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

          const Divider(),

          /// 🔥 DATA PAGE (IMPORTANT PART)
          Expanded(
            child: messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.black12,
              child: SingleChildScrollView(
                child: Text(
                  const JsonEncoder.withIndent('  ')
                      .convert(messages[index]),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),

          /// NAVIGATION (QUIZ STYLE)
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: index == 0
                      ? null
                      : () {
                    setState(() {
                      index--;
                    });
                  },
                  child: const Text("Previous"),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: index == messages.length - 1
                      ? null
                      : () {
                    setState(() {
                      index++;
                    });
                  },
                  child: const Text("Next"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget input(TextEditingController c, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
