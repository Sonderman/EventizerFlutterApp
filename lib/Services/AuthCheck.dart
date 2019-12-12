import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/Firebase.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
                                  locator<DatabaseWorks>(),
                                  locator<StorageWorks>())),
                          ChangeNotifierProvider<EventService>(
                              create: (context) => EventService(
                                  locator<DatabaseWorks>(),
                                  locator<StorageWorks>())),
                          ChangeNotifierProvider<MessagingService>(
                              create: (context) => MessagingService(
                                  locator<DatabaseWorks>(),
                                  locator<StorageWorks>())),
                        ],
                        child: HomePage(),
                      );

                      /*ChangeNotifierProvider<UserService>(
                        builder: (context) => UserService(snapshot.data,
                            locator<DatabaseWorks>(), locator<StorageWorks>()),
                        child: HomePage(),
                      );*/

                    } else {
                      return buildWaitingScreen();
                    }
                  },
                )
              : LoginPage();
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
