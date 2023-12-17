// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';

import '../widget/my_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset('images/logo.png'),
                ),
                Text(
                  'MessageMe',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2e386b),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            MyButton(
              color: Colors.yellow[900]!,
              title: 'Sign in',
              onPressed: () {
                log('sign in ');
                Navigator.pushNamed(context, 'signin_screen');
              },
            ),
            MyButton(
              color: Colors.blue[800]!,
              title: 'register',
              onPressed: () {
                Navigator.pushNamed(context, 'registration_screen');
              },
            )
          ],
        ),
      ),
    );
  }
}
