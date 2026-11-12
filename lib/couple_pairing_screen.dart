import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CouplePairingScreen extends StatefulWidget {
  @override
  _CouplePairingScreenState createState() => _CouplePairingScreenState();
}

class _CouplePairingScreenState extends State<CouplePairingScreen> {
  final TextEditingController _codeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  Future<void> _createCoupleRoom() async {
    setState(() => _isLoading = true);
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        UserCredential userCred = await _auth.signInAnonymously();
        user = userCred.user;
      }

      String coupleId = _firestore.collection('couples').doc().id;

      await _firestore.collection('couples').doc(coupleId).set({
        'members': [user!.uid],
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couple Room Created! Code: $coupleId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _joinCoupleRoom() async {
    String coupleId = _codeController.text.trim();
    if (coupleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid couple code')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      User? user = _
