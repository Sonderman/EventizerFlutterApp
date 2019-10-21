import 'package:flutter/material.dart';
import 'Auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  void _signedOut() async {
    try {
      await auth.signedOut();
      onSignedOut();
    } catch (e) {print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text('Çıkış Yap',style: TextStyle(fontSize: 17.0,color: Colors.white),),
            onPressed: _signedOut
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Text(
            'Welcome',
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
