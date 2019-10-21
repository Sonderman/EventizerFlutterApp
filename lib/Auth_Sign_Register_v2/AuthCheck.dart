import 'package:eventizer/Auth_Sign_Register_v2/HomePage.dart';
import 'package:eventizer/Auth_Sign_Register_v2/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus { Signed, NotSigned }

class AuthCheck extends StatefulWidget {
  //AuthCheck({Key key}) : super(key: key);
final FirebaseAuth _auth = FirebaseAuth.instance;
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  AuthStatus authstatus = AuthStatus.NotSigned;

  @override
  void initState() {
    super.initState();
    Future<String> currentUser() async {
      final FirebaseUser user = await widget._auth.currentUser();
      return user.uid.toString();
    }

    if (currentUser() == null) {
      authstatus = AuthStatus.NotSigned;
    } else {
      authstatus = AuthStatus.Signed;
    }
    print(currentUser());
  }

  @override
  Widget build(BuildContext context) {
    

    if (authstatus == AuthStatus.Signed) {
      return HomePage();
    } else {
      return LoginPage();
    }
  }
}
