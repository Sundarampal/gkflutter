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
  final TextEditingController senderCtrl = TextEditingController();
  final TextEditingController receiverCtrl = TextEditingController();
  final TextEditingController messageCtrl = TextEditingController();

  List<Map<String, String>> chatHistory = [];

  Future<void> _loadData() async {
    final data = await Utilities.downloadJson(
      'https://sundarampal.github.io/myjsonfiles/chatbox.json',
    );

    List chats = data['chats'];

    setState(() {
      chatHistory = chats
          .map((e) => {
        "sender": e['sender'].toString(),
        "receiver": e['receiver'].toString(),
        "message": e['message'].toString(),
      })
          .toList();
    });
  }

  void _sendMessage() {
    if (senderCtrl.text.isEmpty ||
        receiverCtrl.text.isEmpty ||
        messageCtrl.text.isEmpty) return;

    setState(() {
      chatHistory.add({
        "sender": senderCtrl.text,
        "receiver": receiverCtrl.text,
        "message": messageCtrl.text,
      });
    });

    messageCtrl.clear();
  }

  void _showChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatHistoryScreen(chatHistory: chatHistory),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editable Chat JSON")),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _input(senderCtrl, "Sender Name", Colors.blue[100]!),
            _input(receiverCtrl, "Receiver Name", Colors.green[100]!),
            _input(messageCtrl, "Message", Colors.grey[200]!),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _sendMessage,
                    child: const Text("Send"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _showChat,
                    child: const Text("Show Chat"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(TextEditingController c, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: color,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class ChatHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> chatHistory;

  const ChatHistoryScreen({super.key, required this.chatHistory});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chat History")),
      body: chatHistory.isEmpty
          ? const Center(child: Text("No messages"))
          : ListView.builder(
        itemCount: chatHistory.length,
        itemBuilder: (context, index) {
          final chat = chatHistory[index];
          return Card(
            child: ListTile(
              title: Text(chat['message']!),
              subtitle:
              Text("${chat['sender']} ➜ ${chat['receiver']}"),
            ),
          );
        },
      ),
    );
  }
}
