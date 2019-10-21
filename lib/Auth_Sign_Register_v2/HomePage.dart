import 'package:eventizer/Auth_Sign_Register_v2/AuthCheck.dart';
import 'package:eventizer/Auth_Sign_Register_v2/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  //HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Çıkış Yap',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: () {
            FirebaseAuth.instance.signOut();
             Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            'Welcome',
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
