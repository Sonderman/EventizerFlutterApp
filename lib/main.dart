import 'package:flutter/material.dart';
import 'Auth_Sign_Register_v2/AuthCheck.dart';
import 'Auth_Sign_Register_v2/BaseAuth.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: AuthCheck(auth: Auth())
    );
  }
}
