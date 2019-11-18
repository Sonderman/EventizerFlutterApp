import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthProvider.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

String userEmail ="loading..";
  

  void _signedOut(BuildContext context) {
    var auth = AuthProvider.of(context).auth;
    auth.signOut();
    Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AuthCheck()));
  }
  Future<void> _getUserEmail(BuildContext context) async{
    var auth=AuthProvider.of(context).auth;
    userEmail=await auth.getUserEmail();
    setState(() {
      
    });
  }

  @override
  void didChangeDependencies() {
    _getUserEmail(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mail: $userEmail'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Çıkış Yap',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: () => _signedOut(context)
          )
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
