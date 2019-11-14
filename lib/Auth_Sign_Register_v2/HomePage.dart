import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'AuthCheck.dart';
import 'BaseAuth.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;


  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  String userEmail = "null";

  Future<Void> getUserEmail()async{
    userEmail = await widget.auth.getUserEmail();
    setState(() {
      
    });
  }

    @override
     initState(){
      super.initState();
      getUserEmail();
    
    }
    
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AuthCheck(auth: widget.auth)));
              },
            )
          ],
        ),
        body: Container(
          child: Center(
            child: Text(
              'UserId : ${widget.userId} \n UserEmail: $userEmail',
              style: TextStyle(fontSize: 32.0),
            ),
          ),
        ),
      );
    }
}
