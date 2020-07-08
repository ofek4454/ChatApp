import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/chat_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ChatApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.deepOrange,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          }),
    );
  }
}
