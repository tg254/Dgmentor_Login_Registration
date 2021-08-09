import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Registration_page.dart';
import 'textbox.dart';
import 'passwordbox.dart';
import 'Customize_button.dart';
import 'firebase_util.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showSpinner = false;
  String email;
  String password;
  FirebaseUser loggedInUser;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 50, top: 100),
                child: Image.asset(
                  'assets/logo1.jpeg',
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextBox(
                onChanged: (value) {
                  email = value;
                },
                hintText: 'Email',
                icon: Icons.person,
              ),
              Passwordbox(
                onChanged: (value) {
                  password = value;
                },
                hintText: 'Password',
                icon: Icons.lock,
              ),
              CustermizeButton(
                text: 'Login',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);

                    if (user != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FirebaseUtil()),
                      );
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'New User?',
                    style: TextStyle(
                        color: Color(0XFF546E7A), fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistartionPage(),
                          ));
                    },
                    child: Text(
                      '  Register',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
