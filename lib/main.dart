import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'chat_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      ),
      home: const FirebaseInitScreen(),
    );
  }
}

class FirebaseInitScreen extends StatelessWidget {
  const FirebaseInitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Jab tak Firebase connect ho raha hai, loading dikhao
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.pink),
                  SizedBox(height: 16),
                  Text('App connect ho rahi hai...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }
        
        // Agar koi error aayi Firebase initialization mein
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Firebase Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        // Firebase connect hone ke baad seedha ChatScreen khol do
        return ChatScreen(coupleId: 'test_id');
      },
    );
  }
}
