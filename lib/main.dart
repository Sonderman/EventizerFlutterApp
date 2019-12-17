import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        home: SplashScreen(
          seconds: 2,
          backgroundColor: Colors.blue,
          loadingText: Text("Loading"),
          navigateAfterSeconds: AuthCheck(),
          title: Text("Eventizer",
              style: TextStyle(fontSize: 48, color: Colors.deepOrange)),
          loaderColor: MyColors().blueThemeColor,
        ),
      ),
    );
  }
}
