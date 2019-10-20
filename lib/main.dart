import 'package:eventizer/Auth.dart';
import 'package:flutter/material.dart';
import 'package:eventizer/LoginPage.dart';
import 'Root_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(auth: Auth()),
    );
  }
}
