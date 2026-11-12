import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String coupleId;
  const ChatScreen({super.key, required this.coupleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room ($coupleId)'),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          const Expanded(
            child: Center(
              child: Text(
                'Chat Screen Loaded Successfully!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.pink),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
