import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }
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
      home: const TestHomeScreen(),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hum Dono - Connected'),
        backgroundColor: Colors.pink,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Firebase & Flutter Successfully Loaded!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
              onPressed: () {
                // Yahan se aap apne ChatScreen par ja sakte hain
              },
              child: const Text('Open Chat', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
