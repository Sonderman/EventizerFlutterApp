import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'BaseAuth.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;

    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          return isLoggedIn ? HomePage() : LoginPage();
        }
        return buildWaitingScreen();
      },
    );
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
