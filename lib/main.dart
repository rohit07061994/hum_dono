import 'package:flutter/material.dart';
import 'dart:math';

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
        scaffoldBackgroundColor: const Color(0xFF1A0510),
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
    const TruthOrDareTab(),
    const MoodTrackerTab(),
    const FeedbackTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔥 Hum Dono 🔥', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF880E4F),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2D0C1F), Color(0xFF1A0510)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.white60,
        backgroundColor: const Color(0xFF2D0C1F),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Positions'),
          BottomNavigationBarItem(icon: Icon(Icons.local_fire_department), label: 'T/Dare'),
          BottomNavigationBarItem(icon: Icon(Icons.mood), label: 'Mood'),
          BottomNavigationBarItem(icon: Icon(Icons.rate_review), label: 'Maza'),
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
                    color: isMe ? Colors.pink[800] : Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(_messages[index], style: const TextStyle(fontSize: 16, color: Colors.white)),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          color: const Color(0xFF2D0C1F),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Yahan apna message likhein...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send, color: Colors.pinkAccent),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// 2. Positions Tab
class GamesTab extends StatefulWidget {
  const GamesTab({super.key});

  @override
  State<GamesTab> createState() => _GamesTabState();
}

class _GamesTabState extends State<GamesTab> {
  final List<String> titles = [
    '👫 Face-to-Face (Aamne-Samne)',
    '🫂 Spooning (Piche se Gale Lagna)',
    '👑 Upper Control (Upar Rehna)'
  ];

  final List<String> descs = [
    'Tarika: Ek-dusre ke aamne-samne let kar pyaar karna. Isme aankhon mein dekh kar closeness sabse zyada maza deti hai.',
    'Tarika: Ek hi disha mein karwat lekar letna. Bahut aaramdayak aur romantic style hai.',
    'Tarika: Poora control apne haath mein rakhne aur apni marzi se speed adjust karne ki best position.'
  ];

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D0C1F),
        title: const Text('Naya Task ya Position Jodein', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Position ya task ka naam...', hintStyle: TextStyle(color: Colors.white54)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: descController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(hintText: 'Hindi mein detail likhein...', hintStyle: TextStyle(color: Colors.white54)),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Radd Karein', style: TextStyle(color: Colors.white60)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
            onPressed: () {
              if (titleController.text.trim().isNotEmpty && descController.text.trim().isNotEmpty) {
                setState(() {
                  titles.insert(0, '🔥 ${titleController.text.trim()}');
                  descs.insert(0, descController.text.trim());
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
        backgroundColor: Colors.pinkAccent,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Naya Task Jodein', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: titles.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                '🔥 Intimacy Positions & Tasks (Hindi)',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
              ),
            );
          }
          int i = index - 1;
          return Card(
            color: const Color(0xFF381229),
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titles[i], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                  const SizedBox(height: 8),
                  Text(descs[i], style: const TextStyle(fontSize: 15, color: Colors.white70)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// 3. Truth or Dare Tab
class TruthOrDareTab extends StatefulWidget {
  const TruthOrDareTab({super.key});

  @override
  State<TruthOrDareTab> createState() => _TruthOrDareTabState();
}

class _TruthOrDareTabState extends State<TruthOrDareTab> {
  final List<String> truths = [
    'Sach Batao: Apne partner ka kaunsa angh (private part) ya jism ka hissa sabse zyada sexy lagta hai?',
    'Sach Batao: Din mein kitni baar apne partner ke sath bistar par intimate hone ka khayal aata hai?',
    'Sach Batao: Pehli baar partner ko bina kapdo ke dekh kar kya socha tha?',
    'Sach Batao: Aaj raat partner ke kis ang ko sabse pehle choona ya chumma chahte ho?'
  ];

  final List<String> dares = [
    'Himmat Karo: Bina kapdo ke partner ke saamne 1 minute tak khade hokar unhe apni taraf attract karo.',
    'Himmat Karo: Partner ke private part (ling ya yoni) ko apne hothon aur jeebh se 2 minute tak sahlao.',
    'Himmat Karo: Apne partner ke badan par thoda garam tel daalkar poore jism ki malish karo.',
    'Himmat Karo: Partner ke kaan mein apni sabse gandi aur romantic khwahish seedhe shabdo mein bolo.'
  ];

  String currentQuestion = 'Neeche diye gaye button par click karke Sach ya Himmat chunein!';
  String typeTitle = '';

  void getRandomTruth() {
    final random = Random();
    setState(() {
      typeTitle = '💋 Sach (Truth)';
      currentQuestion = truths[random.nextInt(truths.length)];
    });
  }

  void getRandomDare() {
    final random = Random();
    setState(() {
      typeTitle = '🔥 Himmat (Dare)';
      currentQuestion = dares[random.nextInt(dares.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          const Text(
            '🔥 Private Truth or Dare 🔥',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            color: const Color(0xFF381229),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(typeTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                  const SizedBox(height: 16),
                  Text(
                    currentQuestion,
                    style: const TextStyle(fontSize: 18, color: Colors.white, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[800],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: getRandomTruth,
                  child: const Text('Sach (Truth)', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange[800],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: getRandomDare,
                  child: const Text('Himmat (Dare)', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 4. Mood Tracker Tab
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFF381229),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('✨ Aaj ka Mood kaisa hai?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pinkAccent)),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: selectedMood,
                  dropdownColor: const Color(0xFF2D0C1F),
                  style: const TextStyle(color: Colors.white),
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
                  dropdownColor: const Color(0xFF2D0C1F),
                  style: const TextStyle(color: Colors.white),
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
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Apni demand yahan likhein...',
                    hintStyle: TextStyle(color: Colors.white54),
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

// 5. Feedback Tab
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.pinkAccent),
        ),
        const SizedBox(height: 16),
        Card(
          color: const Color(0xFF381229),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
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
                    Text('${rating.toInt()} / 5 Star', style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Colors.amber)),
                  ],
                ),
                Slider(
                  value: rating,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  activeColor: Colors.pinkAccent,
                  inactiveColor: Colors.white24,
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
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Kya sabse zyada achha laga...',
                    hintStyle: TextStyle(color: Colors.white54),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent, padding: const EdgeInsets.symmetric(vertical: 12)),
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
