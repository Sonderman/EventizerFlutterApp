import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  //WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  /* //Test için
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocatorTest(),
      );
  }
 */
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(debugShowCheckedModeBanner: false, home: AuthCheck()
          //home: Login1(),
          ),
    );
  }
}
