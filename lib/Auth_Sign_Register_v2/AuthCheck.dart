import 'package:eventizer/Navigation/HomePage.dart';
import 'package:flutter/material.dart';
import 'BaseAuth.dart';
import 'LoginPage.dart';

enum AuthStatus { Signed, NotSigned, NotDetemined }

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key key, this.auth}) : super(key: key);
  final BaseAuth auth;
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  AuthStatus authstatus = AuthStatus.NotDetemined;
  String _userId = "";

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authstatus = AuthStatus.Signed;
    });
  }

  void logoutCallback() {
    setState(() {
      authstatus = AuthStatus.NotSigned;
      _userId = "";
    });
  }

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authstatus =
            user?.uid == null ? AuthStatus.NotSigned : AuthStatus.Signed;
      });
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authstatus) {
      case AuthStatus.NotDetemined:
        return buildWaitingScreen();
        break;
      case AuthStatus.NotSigned:
        return LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.Signed:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
