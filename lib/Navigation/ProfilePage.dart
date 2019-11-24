import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/UserWorker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  

  void _signedOut(BuildContext context) {
    var auth = AuthProvider.of(context).auth;
    auth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
  }

  Future<String> getUserEmail(BuildContext context) async {
    var auth = AuthProvider.of(context).auth;
    String userEmail = await auth.getUserEmail();
    return userEmail;
    //setState(() {});
  }

  /*@override
  void didChangeDependencies() {
    //getUserEmail(context);
    super.didChangeDependencies();
  }*/

  @override
  Widget build(BuildContext context) {
    final userWorker = Provider.of<UserWorker>(context);
    String userName = userWorker.getName();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0XFF001970),
        elevation: 8.0,
        title: FutureBuilder<String>(
          future: getUserEmail(context),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
              return Text('Mail:${snapshot.data}');
             }else{
               return CircularProgressIndicator();
             }
          },
        ),
        actions: <Widget>[
          FlatButton(
              child: Text(
                'Çıkış Yap',
                style: TextStyle(fontSize: 17.0, color: Colors.white),
              ),
              onPressed: () => _signedOut(context))
        ],
      ),
      body: Center(
        child: Container(
          child: Text('İsim:$userName\nId:${userWorker.getUserId()}'),
        ),
      ),
      /*floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              userWorker.setName("B");
            },
          ),
          FloatingActionButton(
            child: Icon(Icons.remove),
            onPressed: () {
              userWorker.setName("C");
            },
          )
        ],
      ),*/
    );
  }
}
