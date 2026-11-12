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
    const MoodTrackerTab(),
    const FeedbackTab(),
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
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Baatcheet'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Positions & Task'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood Tracker'),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Ratri ka Maza'),
        ],
      ),
    );
  }
}

// 1. Baatcheet (Chat) Tab
class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final List<String> _messages = ['Suno ji, kaise ho?'];
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
                    hintText: 'Yahan apna message likhein...',
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

// 2. Positions & Custom Tasks Tab (Pictorial & Hindi)
class GamesTab extends StatefulWidget {
  const GamesTab({super.key});

  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  final List> intimacyItems = [
    {
      'title': '👫 Face-to-Face (Aamne-Samne)',
      'desc': 'Visual/Tarika: Ek-dusre ke aamne-samne let kar pyaar karna. Isme aankhon mein dekh kar closeness sabse zyada maza deti hai.'
    },
    {
      'title': '🫂 Spooning (Piche se Gale Lagna)',
      'desc': 'Visual/Tarika: Ek hi disha mein karwat lekar letna. Bahut aaramdayak aur romantic style hai.'
    },
    {
      'title': '👑 Upper Control (Upar Rehna)',
      'desc': 'Visual/Tarika: Wife ka poora control apne haath mein rakhne aur apni marzi se speed adjust karne ki best position.'
    },
  ];

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Naya Task ya Position Jodein'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'Position ya task ka naam...'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: 'Hindi mein detail likhein...'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Radd Karein'),
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
            child: const Text('Jodein', style: TextStyle(color: Colors.white)),
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
        label: const Text('Naya Task Jodein', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '🔥 Intimacy Positions & Tasks (Hindi)',
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
                  Text(item['title']!, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                  const SizedBox(height: 8),
                  Text(item['desc']!, style: const TextStyle(fontSize: 15, color: Colors.black87)),
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

// 3. Mood Tracker Tab (Hindi)
class MoodTrackerTab extends StatefulWidget {
  const MoodTrackerTab({super.key});

  @override
  State<MoodTrackerTab> createState() => _MoodTrackerTabState();
}

class _MoodTrackerTabState extends State<MoodTrackerTab> {
  String selectedMood = 'Romantic & Cozy 💕';
  String selectedDesire = 'Special Hug & Quality Time 🤗';
  String customNote = '';

  final List<String> moods = [
    'Romantic & Cozy 💕',
    'Playful & Teasing 😉',
    'Deeply Passionate 🔥',
    'Thoda Thakawat / Aaram Karna hai 😌',
  ];

  final List<String> desires = [
    'Gale Milna aur Time Bitana 🤗',
    'Raat ko Lambi Baatein 🌙',
    'Intimate Time / Romance 🔥',
    'Surprise Gift ya Pampering 🌹',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '👑 Aaj ka Mood aur Mann Tracker',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✨ Aaj ka Mood kaisa hai?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedMood,
                  isExpanded: true,
                  items: moods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedMood = val!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('🔥 Aaj kya karne ka mann hai?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedDesire,
                  isExpanded: true,
                  items: desires.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDesire = val!;
                    });
                  },
                ),
                const SizedBox(height: 20),
                const Text('💌 Apne Pati ke liye Message:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Apni demand yahan likhein...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    customNote = val;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// 4. Feedback Tab (Ratri ka Maza)
class FeedbackTab extends StatefulWidget {
  const FeedbackTab({super.key});

  @override
  State<FeedbackTab> createState() => _FeedbackTabState();
}

class _FeedbackTabState extends State<FeedbackTab> {
  double rating = 5.0;
  String feedbackText = '';
  bool submitted = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          '💋 Ratri ka Maza & Feedback',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pink),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🔥 Aaj raat ka maza kaisa raha?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${rating.toInt()} / 5 Star', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                  ],
                ),
                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: Colors.pink,
                  onChanged: (val) {
                    setState(() {
                      rating = val;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('💌 Dil ki baat yahan likhein:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: 'Kya sabse zyada achha laga...',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (val) {
                    feedbackText = val;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      setState(() {
                        submitted = true;
                      });
                    },
                    child: const Text('Submit Karein 💖', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
