import 'package:flutter/material.dart';
import 'Services/AuthCheck.dart';
import 'Services/AuthProvider.dart';
import 'Services/BaseAuth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
          auth: Auth(),
          child: MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue
        ),
        home: AuthCheck()
      ),
    );
  }
}
