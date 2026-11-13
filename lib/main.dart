import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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

// 1. Real-time Firebase Chat Tab (Fixed Timestamp & Sync)
class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _controller = TextEditingController();
  final DatabaseReference _chatRef = FirebaseDatabase.instance.ref().child('chats');

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    _chatRef.push().set({
      'text': _controller.text.trim(),
      'time': DateTime.now().millisecondsSinceEpoch, // Safe local numeric timestamp
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _chatRef.onValue,
            builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
                return const Center(child: Text('Koi message nahi hai...', style: TextStyle(color: Colors.white54)));
              }
              Map map = snapshot.data!.snapshot.value as Map;
              List messages = map.values.toList();
              messages.sort((a, b) {
                int timeA = (a['time'] ?? 0) is int ? a['time'] : 0;
                int timeB = (b['time'] ?? 0) is int ? b['time'] : 0;
                return timeA.compareTo(timeB);
              });

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.pink[800],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(messages[index]['text'], style: const TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  );
                },
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
class GamesTab extends StatelessWidget {
  const GamesTab({super.key});

  @override
  Widget build(BuildContext context) {
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

    return ListView.builder(
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
    );
  }
}

// 3. Truth or Dare Tab (100 Truth & 100 Dares Updated)
class TruthOrDareTab extends StatefulWidget {
  const TruthOrDareTab({super.key});

  @override
  State<TruthOrDareTab> createState() => _TruthOrDareTabState();
}

class _TruthOrDareTabState extends State<TruthOrDareTab> {
  final List<String> truths = [
    "Pehli baar jab aapne mujhe dekha tha, toh aapke mann mein sabse pehla khayal kya aaya tha?",
    "Agar aapko mujhe kisi ek khas dress mein dekhna ho, toh aap kya pehnana chahenge?",
    "Din ya raat—aapko romantic hona kis waqt sabse zyada pasand hai?",
    "Mera aisa kaunsa angootha ya body part hai jo aapko sabse zyada attract karta hai?",
    "Mere sath kiss karne ka aapka sabse pehla aur yaadgar pal kaunsa tha?",
    "Din bhar mein aisi kaun si baat hoti hai jab aapko meri sabse zyada yaad aati hai?",
    "Agar hum dono akele kisi sunsaan island par ho, toh aap sabse pehle kya karna chahenge?",
    "Mere kis kapde ya outfit mein main aapko sabse zyada hot lagta/lagti hoon?",
    "Aisi kaunsi fantasy hai jo aapne abhi tak kisi ko nahi batayi par mere sath poori karna chahte hain?",
    "Jab main aapke kareeb aata/aati hoon, toh aapke dil ki dhadkan par kya asar hota hai?",
    "Mera kaun sa style ya habit aapko sabse zyada cute lagti hai?",
    "Aaj raat aap mere sath sone se pehle kya sapna dekh rahe the?",
    "Agar aapko mujhe ek romantic gift dena ho, toh aap kya denge?",
    "Mera kaun sa gussa ya roothna aapko sabse zyada pyaar bhara lagta hai?",
    "Humari pehli date ya pehli baar ki baat-chit ki kaun si yaad aapko sabse achhi lagti hai?",
    "Kya aapko public place par romance karna ya haath pakadna pasand hai?",
    "Meri aisi kaun si baat hai jisse aap sabse zyada pyaar karte hain?",
    "Agar aapko ek din ke liye meri jagah aane ka mauka mile, toh aap kya karenge?",
    "Mere sath bitaya gaya ab tak ka sabse best pal kaun sa hai?",
    "Kya aapko mere sath eye-contact karke baatein karna pasand hai?",
    "Mere kis gesture ya smile par aap sabse zyada fida hote hain?",
    "Agar main aapse abhi ek romantic promise maangu, toh aap kya denge?",
    "Aapko mere sath kis tarah ka music ya song sunna sabse zyada pasand hai?",
    "Kya aapko mere sath long drive par jaana pasand hai?",
    "Mera kaun sa message padh kar aapke chehre par sabse badi muskaan aati hai?",
    "Agar hum dono ek romantic movie dekh rahe hon, toh aap kis scene par sabse zyada khoye rahenge?",
    "Aapko mere sath barish mein bheegna kaisa lagta hai?",
    "Mere kis nickname se aapko sabse zyada pyaar hai?",
    "Kya aapko mera haath pakad kar chalna pasand hai?",
    "Agar main aapse kahoon ki abhi sab kuch chhod kar mere paas aa jao, toh aap kya karoge?",
    "Mere sath bitaya gaya sabse funny ya mazakiya moment kaun sa tha?",
    "Aapko meri kaun si adaa sabse zyada niraali lagti hai?",
    "Kya aapko mere sath subah ki chai peena pasand hai?",
    "Mere kis tareeqe se baat karne par aapko gussa aata hai, jo baad mein pyaar mein badal jata hai?",
    "Agar aapko mere liye koi gana gaana pade, toh aap kaun sa gaayenge?",
    "Mere kis surprise ne aapko sabse zyada khush kiya tha?",
    "Kya aapko mere sath cooking karna pasand hai?",
    "Mere bina aapka ek din kaisa guzarta hai?",
    "Aapko mere sath kaun si jagah ghumne jaana sabse zyada pasand hai?",
    "Agar main aapse abhi ek wish maangne ko kahoon, toh aap kya maangenge?",
    "Mere kis style ya fashion sense ki aap sabse zyada tareef karte hain?",
    "Kya aapko mere sath late night baatein karna pasand hai?",
    "Mere kis tareeqe se dekhne par aapko sharam aa jati hai?",
    "Agar hum dono gusse mein hon, toh pehle manane kaun aata hai?",
    "Mere sath jeene ka aapka sabse bada sapna kya hai?",
    "Kya aapko mere gale lag kar sona pasand hai?",
    "Mere kis khana banane ke tareeqe par aap fida hain?",
    "Aapko mere sath photos click karwana kaisa lagta hai?",
    "Agar hum dono kabhi ladai karein, toh sabse pehle dimaag mein kya aata hai?",
    "Aap mujhse kitna aur kis had tak pyaar karte hain?",
    "Aapki sabse pehli secret crush kaun ya kaun thi, jise maine aaj tak nahi jaana?",
    "Agar hume ek raat ke liye kisi hotel ke sabse expensive suite mein rehne mile, toh aap raat kaise bitaana chahenge?",
    "Mera kaun sa undergarment ya innerwear aapko mujhe pehnate hue sabse zyada hot lagta hai?",
    "Jab aap akele hote hain, toh kya aapko kabhi meri aisi romantic ya hot tasveerein dekhne ki aadat hai?",
    "Humari pehli physical intimacy ya close moment ke baad aapke man mein sabse pehla kya thought aaya tha?",
    "Agar main aapko bina kapdo ke ghar ke andar ghumne ko kahoon, toh kya aap maan jaoge?",
    "Aapko mere kis angle ya pose mein sleep karna sabse zyada cute ya sexy lagta hai?",
    "Kya aapko kabhi office ya kisi public place par kaam karte waqt meri aisi yaad aayi hai ki aapka dhoom mach gaya ho?",
    "Mera kaun sa perfume ya body spray ki khushboo aapko sabse zyada paagal karti hai?",
    "Agar main aapse kahoon ki aaj poori raat sirf mere ishare par chalna hai, toh kya aap taiyar hain?",
    "Aapko kis tarah ki dirty talk sabse zyada pasand hai — soft aur sweet ya bilkul bold aur seedhi?",
    "Kya aapko mere sath shower ke niche nahate waqt romance karna pasand hai?",
    "Mera kaun sa aisa private secret hai jo aapko sabse zyada pasand hai?",
    "Agar aapko mujhe kisi ek word mein describe karna ho jo meri hotness aur cuteness dono bataye, toh woh kya hoga?",
    "Kya aapko kabhi sapne mein humare sath koi aisi hot situation dikhi hai jo sach ho jaaye?",
    "Mera kaun sa touch aapko sabse jaldi turn-on kar deta hai?",
    "Agar hum dono kisi beach par hon, toh kya aap mujhe bikini mein dekh kar sabke saamne flirt karoge?",
    "Aapko meri body ka kaun sa hissa sabse zyada perfect lagta hai?",
    "Kya aapko kabhi kisi anjaane se bhi mere jaisa attraction mehsoos hua hai ya main hi sab kuch hoon?",
    "Mera kaun sa gussa dekh kar aapko gussa aane ke bajaye pyaar aa jata hai?",
    "Agar hume ek din ke liye ghar par band kar diya jaye, toh aap apna poora din kaise bitaoge?",
    "Aapko mere sath kiss karte waqt sabse achhi cheez kya lagti hai?",
    "Kya aapne kabhi mirror ke saamne khade hokar meri ya apni hot body ko admire kiya hai?",
    "Mera kaun sa dressing sense aapko sabse zyada bold lagta hai?",
    "Agar main aapko abhi ek aisi demand rakhne ko kahoon jo poori karni hi padegi, toh aap kya mangoge?",
    "Aapko mere sath night walk par haath pakad kar chalna kaisa lagta hai?",
    "Kya aapko meri voice phone par sun kar kabhi turant paas aane ka dil kiya hai?",
    "Mera kaun sa anokha style aapko sabse zyada unique lagta hai?",
    "Agar hum dono bina phone ke ek pura din bitayein, toh kya aap bore hoge ya mere sath khoye rahoge?",
    "Aapko mere sath kitchen mein romance karna kaisa lagta hai?",
    "Kya aapko meri kisi purani photo ko dekh kar abhi bhi wahi crush wala feeling hota hai?",
    "Mera kaun sa habit hai jo aapko thoda pareshan karta hai par pyaar ki wajah se aap seh lete ho?",
    "Agar aapko mujhe koi naya romantic naam dena ho, toh aap kya doge?",
    "Aapko mere sath long drive par kis gaane ki yaad sabse zyada aati hai?",
    "Kya aapko mujhe tease karna ya tang karna pasand hai?",
    "Mera kaun sa message padh kar aap office ya kaam ke beech mein bhi hasne lagte ho?",
    "Agar hum dono kabhi purane dino ko yaad karein, toh aapko sabse pyari yaad kaun si lagti hai?",
    "Aapko mere sath coffee peena ya date par jana kis jagah sabse zyada pasand hai?",
    "Kya aapko meri care karna aur meri har choti baat ka dhyan rakhna achha lagta hai?",
    "Mera kaun sa look sabse zyada aapke dil ke kareeb hai?",
    "Agar main aapko ek surprise date plan karne ko kahoon, toh aap kahan le jaoge?",
    "Aapko mere sath kis baat par sabse zyada hasi aati hai?",
    "Kya aapko mere sath bed par late night movies dekhna pasand hai?",
    "Mera kaun sa gift aapke paas sabse special jagah par rakha hai?",
    "Agar humari kabhi ladai ho, toh aapko kis cheez se sabse zyada darr lagta hai?",
    "Aapko mere sath subah uthte hi sabse pehla kya karne ka dil karta hai?",
    "Kya aapko mere sath apne future ki baatein karna pasand hai?",
    "Mera kaun sa sapna hai jise aap mere sath mil kar poora karna chahte hain?",
    "Agar aapko mujhe ek line mein compliment dena ho, toh aap kya bologe?",
    "Kya aapko lagta hai ki humari jodi duniya ki sabse best jodi hai?"
  ];

  final List<String> dares = [
    "Partner ke lund ya chut ko bina ruke kam se kam 15 se 20 minute tak lagataar chatna ya chusna.",
    "Apne bathroom mein ek-ek karke apne saare kapde utaar kar nange hokar sath mein nahana.",
    "Partner ki poori body par oil ya lotion se ache se malish karna, khaas kar intimate areas par.",
    "Partner ke doodh (breasts) ko apne haath se dabana aur apne hotho se pyaar karna.",
    "Apni ungli se partner ki gand aur chut ko dheere-dheere sahlaate hue explore karna.",
    "Ghar ka main darwaza ya balcony thoda kholkar ya wahan khade hokar partner ke sath intimate hona.",
    "Room ki khidki ya curtain thoda hata kar adventurous style mein partner ke sath sex karna.",
    "Bikini, bra-panty, ya saree pehnkar, achhi si lipstick lagakar partner ke saamne aana aur hot dance karna.",
    "Partner ke pet aur chest par apni garam saansein chhodte hue hot kisses ke nishaan banana.",
    "Partner ke baalo mein haath pherte hue unke kaan ke paas sabse gandi aur hot baatein (dirty talk) karna.",
    "Partner ke gale aur lips par bina ruke 2 minute tak continuous deep kiss karna.",
    "Partner ke kaan mein unke naam ke sath ek sabse hot aur romantic fantasy dheere se bolna.",
    "Partner ki peeth par apni jeebh se ek lambi line banana.",
    "Partner ke buttocks par apne hath se halka sa spank (thappad) lagana aur fir wahan kiss karna.",
    "Partner ki jaangho (thighs) ke andar wale hisse par dheere-dheere haath pherna aur sahlaana.",
    "Partner ke sath 2 minute tak bina kapdo ke ek-dusre ko tight hug karke khade rehna.",
    "Partner ki naabhi par thodi si chocolate ya cream rakh kar use chat kar saaf karna.",
    "Partner ke saamne apne ek-ek karke kapde utaar kar unhe apna hot dance ya look dikhana.",
    "Partner ke pairo ke talwe (soles) ko apne muh se chuna aur halka sa chatna.",
    "Partner ki ankhon par patti bandh kar unke alag-alag body parts ko apne hotho se chhoona.",
    "Partner ko god mein uthana aur room mein nange hokar chakkar lagana.",
    "Partner ke gaal par ek jor se kiss karke sound nikalna.",
    "Partner ki thuddi (chin) ko pakad kar unka chehra upar uthana aur aankho mein dekhna.",
    "Partner ke haath ki hatheli (palm) par apni jeebh se halka sa gundgundi karna.",
    "Partner ke sath aisi jagah baithna jahan halka andhera ho aur sirf ek-dusre ki saansein sunai dein.",
    "Partner ki peeth par apne naakhunon se halka-halka scratch karte hue romance karna.",
    "Partner ke saamne khade hokar apni pasand ka koi bhi ek sabse bold aur hot step perform karna.",
    "Partner ke gale par apne hotho se ek deep love bite dena.",
    "Partner ke haath ki ungliyon ko ek-ek karke apne muh mein lekar chusna.",
    "Partner ke sath mirror ke samne khade hokar apni body ko ek baar dhyan se dekhna.",
    "Partner ke lund ya chut ke aas-pass apni garam saansein chhodna bina touch kiye kuch der tak.",
    "Partner ke sath floor par let kar ek-dusre ki body ko poori tarah explore karna.",
    "Partner ke pairo ki ungliyon (toes) ko ek-ek karke pyaar karna.",
    "Partner ki poori baah (arm) par shoulder se lekar ungliyon tak kiss karna.",
    "Partner ke hotho par chocolate ya honey lagakar use apni jeebh se chat kar saaf karna.",
    "Partner ke sath bed par let kar ek-dusre ke upar roll karna bina kapdo ke.",
    "Partner ke hotho par apni ungli pherna aur fir wahi ungli apne muh mein rakhna.",
    "Partner ke stomach par apne honth rakh kar halka sa blow karna aur kiss karna.",
    "Partner ki kamar (waist) ko apne hatho se pakad kar unhe apni taraf khinchna aur tight hug karna.",
    "Partner ke gal par apni jeebh se ek gol chakkar banakar kiss karna.",
    "Partner ke chhate par apna sar rakh kar unki dil ki dhadkan sunna.",
    "Partner ko peeche se hug karna aur unki gardan par kissing karna.",
    "Partner ke samne ghutno par baith kar unka haath pakadna aur apne pyaar ka izhaar karna.",
    "Partner ke kaan ke lobes ko apne hotho se halka sa kaatna aur pyaar karna.",
    "Partner ke sath bistar par let kar ek-dusre ki saansein mehsoos karna 2 minute tak bina bole.",
    "Partner ke liye bina bole 2 minute tak aankh mein aankh daal kar sirf muskurate rehna.",
    "Partner ki koi ek aisi aadat ki nakal utaar kar dikhana jo aapko sabse zyada bold lagti ho.",
    "Partner ko bina bataye unke liye koi ek spicy ya sexy gesture choose karke dikhana.",
    "Partner ke sath dim lights mein ek slow aur erotic dance perform karna bina kisi kapde ke.",
    "Partner ke saamne khade hokar unhe apni poori body ka ek hot turn-around (round) dikhana.",
    "Partner ke lund ko apne haath mein lekar 5 minute tak masturbate karna jab tak woh poora hard na ho jaye.",
    "Partner ki chut par apni jeebh se circular motion mein chatte hue unhe jaldi se trigger karna.",
    "Partner ke saamne bilkul nange hokar unki god mein baith jana aur unhe kiss karna.",
    "Partner ki gand ke ched par apni ungli se halka sa pressure dete hue massage karna.",
    "Partner ke lund ko apne dono hotho ke beech mein lekar deep throat challenge 2 minute tak dena.",
    "Partner ki chut ke andar do ungliyan dalakar andar-bahar fast move karna 3 minute tak.",
    "Partner ke saare kapde apne hathon se dheere-dheere ek-ek karke utaar kar unhe nanga karna.",
    "Partner ke nipples par ice cube ghumate hue apne hotho se unhe garam karna.",
    "Partner ko bed par ghutno ke bal jhuka kar peeche se unke sath intimate pose banana.",
    "Partner ki poori thighs aur buttocks par zor-zor se apne hathon se thappad (spanking) lagana.",
    "Partner ki jeebh ko apni jeebh ke sath lock karke 3 minute tak bina saas roke French kiss karna.",
    "Partner ke pairo ke beech mein baith kar unke private part ko bina ruke chatna aur unhe pagal karna.",
    "Partner ke kaan mein unhe apni saari gandi aur hot fantasies English ya Hindi mein whisper karna.",
    "Partner ke pet se lekar gale tak apni poori jeebh se trail banate hue chatna.",
    "Partner ke sath sofa ya bed par missionary position mein bina protection ke sex karne ki shuruaat karna.",
    "Partner ke haath mein apna phone dekar unhe apni ek hot aur naked selfie click karne dena.",
    "Partner ki naabhi se niche tak apni jeebh ghumate hue unke sensitive spots ko explore karna.",
    "Partner ke lund par thoda sa oil lagakar apni muthi se fast stroke dena jab tak woh release na hone lage.",
    "Partner ki chut ke upar apne hoth rakh kar zor se blow karna aur unhe shivering feel karwana.",
    "Partner ke sath bathroom ke mirror ke saamne nange hokar ek-dusre ko gale lagana.",
    "Partner ki kamar ko pakad kar unhe deewar par utha kar (wall pin) kiss karna.",
    "Partner ke pairo ki ungliyon se lekar jaangho tak apni jeebh se chatte hue upar aana.",
    "Partner ke baalon ko muthi mein pakad kar unka chehra apni taraf khinchna aur hotho par kiss karna.",
    "Partner ke saamne bed par let kar apni chut ya lund ko khud apne hathon se rub karna.",
    "Partner ke gale par ek gehra love bite dena jo agle din tak nazar aaye.",
    "Partner ki aankhon par patti bandh kar unke poore sharir par apne nange badan ko ragadna.",
    "Partner ke kan ke lobe ko apne daanton se halka sa kaat kar wahan garam saansein chhodna.",
    "Partner ke sath 5 minute tak bina hile ek-dusre ki ankhon mein dekh kar heavy breathing karna.",
    "Partner ke haath ki hatheli par apna private part touch karke unhe garam feel karwana.",
    "Partner ke saamne ghutno par baith kar unke lund ko apne muh mein lena aur ankhon mein dekhna.",
    "Partner ki chut ke lips (labia) ko apne hathon se khol kar andar ki taraf jeebh lagana.",
    "Partner ke sath room ki saari lights band karke sirf touch aur feeling ke zariye intimacy karna.",
    "Partner ke chest par apne nange boobs ko ragadte hue unhe paagal karna.",
    "Partner ke sath ek aisi position try karna jo aapne pehle kabhi try na ki ho.",
    "Partner ke kano mein apni aawaz ko bahut hi sexy aur slow karke unhe gandi baatein sunana.",
    "Partner ke buttocks ke beech mein apni jeebh ghumana aur wahan soft kisses dena.",
    "Partner ke lund ki supari par apne saliva (thook) ko laga kar halka sa suck karna.",
    "Partner ki chut ke andar apni ungli daal kar check karna ki woh kitni geeli (wet) ho chuki hai.",
    "Partner ke sath floor par let kar ek chadar bichakar wahan poori tarah nange hokar let jana.",
    "Partner ke hotho par apne daant se halka sa bite karke unhe apne kareeb khinchna.",
    "Partner ki peeth par upar se niche tak apne nakhunon se soft scratching karte hue chalna.",
    "Partner ke sath ek-dusre ke upar let kar bina kapdo ke body temperature ko feel karna.",
    "Partner ke pet ke nichle hisse par apne garam hoth rakh kar 2 minute tak bina hile rehna.",
    "Partner ke lund ya chut ko apne dono hathon se pakad kar zor se squeeze karna.",
    "Partner ke saamne ek sexy walk karke aana aur unke god mein aakar baith jana.",
    "Partner ke kaan mein bolna ki aap unhe abhi ke abhi kitna buri tarah se chahte ho.",
    "Partner ki poori body par apne hathon se heavy massage karte hue unhe turn-on karna.",
    "Partner ke sath bathroom ke floor par baith kar ek-dusre ko nahlate waqt intimate touch dena.",
    "Partner ke hotho par apni jeebh ferte hue unke muh ke andar tak jeebh dal kar kiss karna.",
    "Partner ke sath ek-dusre ki saari sharm mita kar poori tarah se wild ho jana."
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
                  items: [
                    'Romantic & Cozy 💕',
                    'Playful & Teasing 😉',
                    'Deeply Passionate 🔥',
                    'Thoda Thakawat / Aaram Karna hai 😌'
                  ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedMood = val!;
                    });
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
class FeedbackTab extends StatelessWidget {
  const FeedbackTab({super.key});

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
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Aapke feedback ke liye shukriya! Apni raat ko aur romantic banayein.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}
