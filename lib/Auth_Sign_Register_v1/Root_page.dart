import 'Home_page.dart';
import 'package:flutter/material.dart';
import 'LoginPage.dart';
import 'Auth.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus { SignedIn, NotSignetIn }

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NotSignetIn;
  @override
  initState() {
    super.initState();
    widget.auth.currentUser().then((userID) {
      setState(() {
        authStatus =
            userID == null ? AuthStatus.NotSignetIn : AuthStatus.SignedIn;
      });
    });
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.SignedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.NotSignetIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (authStatus == AuthStatus.NotSignetIn) {
      return LoginPage(auth: widget.auth, onSignedIn: _signedIn);
    } else if (authStatus == AuthStatus.SignedIn) {
      return HomePage(
        auth: widget.auth,
        onSignedOut: _signedOut,
      );
    }
  }
}
