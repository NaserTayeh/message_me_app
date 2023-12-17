import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messageme_app/screens/chat_screen.dart';
import 'package:messageme_app/screens/registration_screen.dart';
import 'package:messageme_app/screens/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> _firebaseMessagingBackdoundHandler(message) async {
  Firebase.initializeApp();
  print('Handling back message $message');
}

void main() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackdoundHandler);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MessageMe app',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationScreen(),
      initialRoute:
          _auth.currentUser != null ? 'chat_screen' : 'welcome_screen',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'signin_screen': (context) => SignInScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'chat_screen': (context) => ChatScreen(),
      },
    );
  }
}
