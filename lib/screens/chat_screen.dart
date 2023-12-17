// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, curly_braces_in_flow_control_structures

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:messageme_app/screens/add_post.dart';
import 'package:messageme_app/screens/post_screen.dart';
import 'package:messageme_app/screens/user_information_screen.dart';

final _firestore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? messageText;

  AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
          'high_importance_channel',
          'High Importance Notifications',
          'This channel is used for important notification',
          importance: Importance.max);
  late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  Future<void> declare() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    log('message');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              androidNotificationChannel.id,
              androidNotificationChannel.name,
              androidNotificationChannel.description,
              icon: android?.smallIcon,
            )));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  late User signedInUser;
  void getCurrentUser() async {
    log('inside get current user');
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   log('in func');
  // final messages = await _firestore.collection('messages').get();
  //   messages.docs.forEach((element) {
  //     print(element.data());
  //   });
  // }
  void messagesStreams() async {
    await _firestore.collection('messages').snapshots().forEach((snapshot) {
      snapshot.docs.forEach((message) {
        print(message.data());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('the message is ' + message.notification.toString());
      RemoteNotification notification = message.notification!;
      AndroidNotification android = message.notification!.android!;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
              androidNotificationChannel.id,
              androidNotificationChannel.name,
              androidNotificationChannel.description,
              icon: android?.smallIcon,
            )));
      }
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Row(
          children: [
            Image.asset('images/logo.png', height: 25),
            SizedBox(width: 10),
            Text('MessageMe')
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // add here logout function
              // _auth.signOut();
              // Navigator.pushReplacementNamed(context, 'welcome_screen');
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return AddPost();
                },
              ));
            },
            icon: Icon(Icons.close),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.orange,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        hintText: 'Write your message here...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': FirebaseAuth.instance.currentUser!.email,
                        'time': FieldValue.serverTimestamp()
                      });
                      messageTextController.clear();
                    },
                    child: Text(
                      'send',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageLine extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  MessageLine({required this.sender, required this.text, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(fontSize: 12, color: Colors.yellow[900]),
          ),
          Material(
              elevation: 5,
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
              color: isMe ? Colors.blue[800] : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  '$text',
                  style: TextStyle(
                      fontSize: 15,
                      color: isMe ? Colors.white : Colors.black45),
                ),
              )),
        ],
      ),
    );
  }
}

class MessageStreamBuilder extends StatelessWidget {
  const MessageStreamBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        log('here i am');
        // log(snapshot.data!.docs.length.toString());
        List<MessageLine> messageWidgets = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        messages.forEach((element) {
          final messageText = element.get('text');
          final messageSender = element.get('sender');
          final currentUser = FirebaseAuth.instance.currentUser!.email;
          final messageWidget = MessageLine(
            text: messageText,
            sender: messageSender,
            isMe: currentUser == messageSender,
          );
          messageWidgets.add(messageWidget);
        });

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
