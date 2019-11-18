import 'dart:io';

import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'RegisterDialog.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String userId;
  String _email;
  String _password;
  
  

  bool validateAndSave() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  Future<void> validateAndSubmit() async {
    if (validateAndSave()) {
      var auth = AuthProvider.of(context).auth;
      userId = await auth.signIn(_email, _password);

      if (userId == null) {
        Fluttertoast.showToast(
            msg: "Şifre veya Eposta yanlış!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 18.0);
      } else {
        print('Signed in: $userId');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        centerTitle: true,
        title: Text('Sisteme Giriş'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 300,
                height: 200,
                //color: Colors.red,
                /*child: Image.network(
                  'https://picsum.photos/250?image=9',
                )*/
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Giris Yapınız'),
              ),
              Form(
                  key: formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Eposta'),
                        validator: (value) =>
                            value.isEmpty ? 'Email boş olamaz' : null,
                        onSaved: (value) => _email = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Şifre'),
                        validator: (value) =>
                            value.isEmpty ? 'Şifre boş olamaz' : null,
                        onSaved: (value) => _password = value,
                        obscureText: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: BorderRadius.circular(30.0),
                          //elevation: 5.0,
                          child: MaterialButton(
                            onPressed: validateAndSubmit,
                            minWidth: 150.0,
                            height: 50.0,
                            color: Color(0xFF179CDF),
                            child: Text(
                              "Giriş",
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      RegisterDialog()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Hesabım yok",
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
