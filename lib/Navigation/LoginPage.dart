import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/AuthCheck.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'RegisterPage.dart';

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
      Firestore.instance.collection('users').document(userId).updateData(
          {"LastLoggedIn": FieldValue.serverTimestamp()}).whenComplete(() {
        print('Başarılı: lastlogin set edildi!');
      }).catchError((e) {
        print(e);
      });

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
      backgroundColor: Color(0xFF004d40),
      appBar: AppBar(
        //backgroundColor: Colors.red,
        elevation: 2.0,
        centerTitle: true,
        title: Text('Sisteme Giriş'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                    width: 350,
                    height: 250,
                    child:
                        Image(image: AssetImage('assets/images/etkinlik.jpg'))),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Giriş Yapınız',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Card(
                  elevation: 8.0,
                  child: Form(
                      key: formkey,
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
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
                                          RegisterPage()));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Hesabım yok",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
