import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  String? _photoURL;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('user').doc(user!.uid).get();
      if (userData.exists) {
        setState(() {
          _photoURL = userData['photoURL'] ?? 'https://avatars.githubusercontent.com/u/1';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              _photoURL ?? "https://avatars.githubusercontent.com/u/56789",
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                return Image.network(
                  'https://avatars.githubusercontent.com/u/56789',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              '${user?.email ?? 'Non disponible'}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
