import 'package:eventizer/Auth_Sign_Register_v2/LoginPage.dart';
import 'package:flutter/material.dart';
import 'Auth_Sign_Register_v2/AuthCheck.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: LoginPage(),
    );
  }
}
