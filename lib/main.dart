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
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();
  final TextEditingController msgCtrl = TextEditingController();

  /// JSON based chat data
  List<Map<String, String>> messages = [
    {"from": "A", "to": "B", "text": "Hello"},
    {"from": "B", "to": "A", "text": "Hi"},
  ];

  void sendMessage() {
    if (fromCtrl.text.isEmpty ||
        toCtrl.text.isEmpty ||
        msgCtrl.text.isEmpty) return;

    setState(() {
      messages.add({
        "from": fromCtrl.text,
        "to": toCtrl.text,
        "text": msgCtrl.text,
      });
    });

    msgCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("JSON Chat")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                inputBox(fromCtrl, "From"),
                inputBox(toCtrl, "To"),
                inputBox(msgCtrl, "Message"),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: sendMessage,
                    child: const Text("Send"),
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(msg['from']!),
                  ),
                  title: Text(msg['text']!),
                  subtitle:
                  Text("${msg['from']} ➜ ${msg['to']}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget inputBox(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
