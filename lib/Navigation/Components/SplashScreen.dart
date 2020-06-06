import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  authChecking(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      locator<AuthService>().getUserUid().then((userID) {
        if (userID != null) {
          print("UserID:" + userID);
          Provider.of<UserService>(context, listen: false)
              .userInitializer(userID)
              .then((value) {
            if (value)
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
          });
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginPage()));
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authChecking(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // ANCHOR  background image icin renk karisimini saglayan bir ozellik
      // ANCHOR  2 den fazla renk eklenebilir https://alligator.io/flutter/flutter-gradient/
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.red]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Eventizer",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontFamily: 'IndieFlower',
                fontSize: 50,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              )),
          // ANCHOR  text ile loading isareti arasina 200 height birakir
          SizedBox(
            height: 200.0,
          ),
          // ANCHOR bu nedir çok kullanım görünüyor bunun için "Flutter Performance" ekranında?
          // ANCHOR  spinkit package kullanildi https://pub.dev/packages/flutter_spinkit
          SpinKitFoldingCube(
            color: Colors.white,
            size: 100.0,
            duration: Duration(seconds: 2),
          ),
          SizedBox(height: 50.0),
          Text(
            "Loading",
            style: TextStyle(
              decoration: TextDecoration.none,
              fontFamily: 'IndieFlower',
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
