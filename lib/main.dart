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
      future: Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyDummyKeyForTestingOnly12345", // Hum test mode ke liye direct config use kar rahe hain
          appId: "1:1234567890:android:abcde12345",
          messagingSenderId: "1234567890",
          projectId: "hum-dono-app",
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Colors.pink),
                  SizedBox(height: 16),
                  Text('Connect ho raha hai...', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }
        
        // Agar fir bhi error aaye toh seedha chat screen khol do taaki UI test ho sake
        if (snapshot.hasError) {
          debugPrint("Firebase init bypass error: ${snapshot.error}");
        }

        return ChatScreen(coupleId: 'test_id');
      },
    );
  }
}
