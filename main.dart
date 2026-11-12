import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'couple_pairing_screen.dart'; // Yeh wahi file hai jo aapne abhi banai hai

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hum Dono',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: CouplePairingScreen(),
    );
  }
}
