import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/Old/OldLoginPage.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthService.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          return isLoggedIn
              ? FutureBuilder<String>(
                  future: auth.getUserUid(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.data != null) {
                      return MultiProvider(
                        providers: [
                          ChangeNotifierProvider<UserService>(
                              create: (context) => UserService(
                                    snapshot.data,
                                  )),
                          ChangeNotifierProvider<EventService>(
                              create: (context) => EventService()),
                          ChangeNotifierProvider<MessagingService>(
                              create: (context) => MessagingService()),
                        ],
                        child: HomePage(),
                      );
                    } else {
                      return buildWaitingScreen();
                    }
                  },
                )
              : OldLoginPage();
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
