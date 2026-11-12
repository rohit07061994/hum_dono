import 'package:flutter/material.dart';

void main() {
  runApp(const HumDonoApp());
}

class HumDonoApp extends StatelessWidget {
  const HumDonoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hum Dono',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFFF0F5),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const ChatTab(),
    const GamesTab(),
    const SecretsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('❤️ Hum Dono ❤️', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.pink,
        centerTitle: true,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Intimacy & Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Secrets'),
        ],
      ),
    );
  }
}

// 1. Chat Tab
class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<String> _messages = ['hi'];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_controller.text.trim());
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              bool isMe = index % 2 == 0;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.pink[100] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_messages[index], style: const TextStyle(fontSize: 16)),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Apna message likhein...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.pink),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 2. Intimacy & Custom Tasks Tab
class GamesTab extends StatefulWidget {
  const GamesTab({super.key});

  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  final List> intimacyItems = [
    {
      'title': '🔥 Missionary / Face-to-Face',
      'desc': 'Sabse classic aur emotional connection banane wali position, jisme eye contact aur closeness sabse zyada hoti hai.'
    },
    {
      'title': '💫 Spooning Position',
      'desc': 'Aaramdayak aur romantic, late kar ek-dusre ke kareeb aane ke liye sabse best.'
    },
    {
      'title': '🌹 Cowgirl / Reverse Cowgirl',
      'desc': 'Partner ke paas poora control aur freedom dene wali exciting position.'
    },
    {
      'title': '✨ Doggy Style / Back View',
      'desc': 'Deep penetration aur intense passion ke liye sabse pasand ki jaane wali style.'
    },
    {
      'title': '💖 Romantic Dare',
      'desc': 'Apne partner ke kaan mein koi aisi baat bolo jo aaj tak kisi ko na batayi ho!'
    }
  ];

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Naya Task / Position Add Karein'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Task ya Position ka naam...'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: 'Task ki detail Hindi mein likhein...'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty && descController.text.trim().isNotEmpty) {
                setState(() {
                  intimacyItems.insert(0, {
                    'title': '🔥 ${titleController.text.trim()}',
                    'desc': descController.text.trim(),
                  });
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Add Karein', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        backgroundColor: Colors.pink,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Naya Task', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🔥 Intimacy & Custom Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
          ),
          const SizedBox(height: 12),
          ...intimacyItems.map((item) => Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title']!,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item['desc']!,
                    style: const TextStyle(fontSize: 15, color: Colors.black87),
                  ),
                ],
              ),
            ),
          )),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

// 3. Secrets Tab
class SecretsTab extends StatelessWidget {
  const SecretsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Text(
          '🔒 Yahan aap dono apne secret notes aur dil ki baatein save karke rakh sakte ho!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, color: Colors.brown),
        ),
      ),
    );
  }
}
