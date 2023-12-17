import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  void initState() {
    super.initState();
    _fcm.requestPermission();
    _fcm.getToken().then((value) => log("the token is: " + value!.toString()));

    // updatePost("p3vjZpKzHL8mybS4aYoB");

    // _fcm.getToken().then((token) {
    //   FirebaseFirestore.instance.collection('tokens').add({'token': token});
    // });
  }

  static Future<void> pushNotification() async {
    final body = {
      "to":
          "e0Zs12XURaWLHXfk2t_IFD:APA91bHJjPvnBMLDAiUtDW-EqzyvwSTEFeM8-EVXWVN-qiHvGPutouLpe3iROd3wevnIF3XTP6l2GlLRnJcE9o_VNYQvJG7rkSljPa2wGNU_lLqZlPKICYbIT7LiD4MfXCDcb46shk-z",
      "notification": {
        "title": "majdy sabra ",
        "body": "Hello from POOOOOOOOOOOOOST"
      }
    };
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var response = await http.post(url,
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAApKqjWYM:APA91bETL0SH47NZXQwfm7nXhHrg-msDEt5GTHim1By6-qcXAjc3bJhXZzd_iX581RvlJVTMJJ1jCAgqqPYcXgkExzdrLEA9fL2LCfpwgev38WTJd_99EfDL3pVrAkmZ5l6HlP9t1AMb'
        },
        body: jsonEncode(body));
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    // log(await http.read(Uri.https('example.com', 'foobar.txt')));
  }

  final _formkey = GlobalKey<FormState>();

  TextEditingController _post_title = TextEditingController();

  TextEditingController _post_descripition = TextEditingController();

  @override
  void dispose() {
    _post_title.dispose();

    _post_descripition.dispose();

    super.dispose();
  }

  // updatePost(String ID) {
  //   FirebaseFirestore.instance.collection('posts').document(ID).setData({
  //     'title': "Title Edited",
  //     'description': "Description Edited"
  //   }).then((value) {
  //     print('record updated successflly');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard / Add Post'),
        actions: <Widget>[
          ElevatedButton(
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () async {
                pushNotification();
                // await FirebaseAuth.instance.signOut();
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (context) => LoginScreen()));
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _post_title,
                decoration: InputDecoration(
                  hintText: 'Post Title',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Fill Post Title Input';
                  }
                  // return 'Valid Name';
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                controller: _post_descripition,
                decoration: InputDecoration(
                  hintText: 'Description',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please Fill Description Input';
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                // color: Colors.blue,
                child: Text(
                  'Add Post',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    // add post
                    var current_user = await FirebaseAuth.instance.currentUser!;
                    FirebaseFirestore.instance.collection('posts').doc().set({
                      'post_title': _post_title.text,
                      'post_description': _post_descripition.text,
                      'user': {
                        'uid': current_user.uid,
                        'email': current_user.email,
                      }
                    });
                  }
                },
              ),
              ElevatedButton(
                child: Text(
                  'Delete Post',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    // Delete post

                    FirebaseFirestore.instance
                        .collection('posts')
                        .doc('hIbH9XJv5Fkt2YzN2wII')
                        .delete()
                        .then((onValue) {
                      print('Post Deleted Successfully');
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
