import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseUtil extends StatefulWidget {
  @override
  _FirebaseUtilState createState() => _FirebaseUtilState();
}

class _FirebaseUtilState extends State<FirebaseUtil> {
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;
  //FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Text('Hiii')],
      ),
    );
  }
}
