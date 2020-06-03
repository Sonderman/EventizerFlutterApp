import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  //ANCHOR burada ekranın dönmesi engellenir, dikey mod
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //ANCHOR status barı transparent yapıyor
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ANCHOR Burası Splash ekran olusturmak için
  Future redirectAuth() {
    return Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return AuthService(
      auth: Auth(),
      child: MaterialApp(
          debugShowMaterialGrid: false,
          debugShowCheckedModeBanner: false,
          supportedLocales: const <Locale>[
            Locale('en', 'US'),
            Locale('tr', 'TR')
          ],
          home: FutureBuilder(
              future: redirectAuth(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snap) {
                if (snap.connectionState == ConnectionState.done) {
                  return AuthCheck();
                } else {
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
              })),
    );
  }
}
