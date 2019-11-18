import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:flutter/material.dart';
import 'AuthProvider.dart';
import 'BaseAuth.dart';

//enum AuthStatus { Signed, NotSigned, NotDetemined }

class AuthCheck extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

final BaseAuth auth =AuthProvider.of(context).auth;
return StreamBuilder<String>(
  stream: auth.onAuthStateChanged,
  builder: (BuildContext context,AsyncSnapshot<String> snapshot){
    if(snapshot.connectionState == ConnectionState.active){
      final bool isLoggedIn = snapshot.hasData;
      return isLoggedIn ? HomePage() : LoginPage() ;
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


  //AuthStatus authstatus = AuthStatus.NotDetemined;

  
// InıtState yerine didchangedependencies kullan!!!
/*  @override
  void didChangeDependencies() {
    var auth = AuthProvider.of(context).auth;
    auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authstatus =
            user?.uid == null ? AuthStatus.NotSigned : AuthStatus.Signed;
      });
    });
    super.didChangeDependencies();
  }

  void loginCallback() {
    var auth = AuthProvider.of(context).auth;
    auth.getCurrentUser().then((user) {
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
*/
 

    /*switch (authstatus) {
      case AuthStatus.NotDetemined:
        return buildWaitingScreen();
        break;
      case AuthStatus.NotSigned:
        return LoginPage(
          loginCallback: loginCallback
        );
        break;
      case AuthStatus.Signed:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            logoutCallback: logoutCallback
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }*/