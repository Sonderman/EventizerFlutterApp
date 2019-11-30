import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/FirebaseDb.dart';
import 'package:eventizer/Services/UserWorker.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'BaseAuth.dart';

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;

    /*Future<void> yazdirUid() async {
       print('AuthCheck UID: ${await auth.getUserUid()}');
    }
    yazdirUid();
    */

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
                    if (snapshot.connectionState == ConnectionState.done) {
                      return ChangeNotifierProvider<UserWorker>(
                        builder: (context) =>
                            UserWorker(snapshot.data, locator<StorageWorks>()),
                        child: HomePage(),
                      );
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
