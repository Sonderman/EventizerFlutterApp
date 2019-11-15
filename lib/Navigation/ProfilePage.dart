import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
void _signedOut()async{

}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı adı'),
        actions: <Widget>[
          FlatButton(child: Text('Çıkış Yap',style: TextStyle(fontSize: 17.0,color: Colors.white),), onPressed: _signedOut,)
        ],
      ),
      body: Center(
        child: Container(
          child: Text('TestBody'),
        ),
      ),
    );
  }
}
