import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'RegisterPage.dart';
import 'package:eventizer/animations/FadeAnimation.dart';

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
      var auth = AuthService.of(context).auth;
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
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 400,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -40,
                  height: 400,
                  width: width,
                  child: FadeAnimation(
                    1,
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  height: 400,
                  width: width + 20,
                  child: FadeAnimation(
                    1.3,
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background-2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Form(
            key: formkey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                    1.5,
                    Text(
                      "Giriş",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                    1.7,
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Colors.grey[200],
                              ),
                            )),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email Adress",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) => value.isEmpty
                                  ? 'Email Adress Boş Olamaz'
                                  : null,
                              onSaved: (value) => _email = value,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Şifre",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) => value.isEmpty
                                  ? 'Email Adress Boş Olamaz'
                                  : null,
                              onSaved: (value) => _password = value,
                              obscureText: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                    1.7,
                    Center(
                        child: Text(
                      "Şifremi Unuttum?",
                      style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),
                    )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                    1.9,
                    MaterialButton(
                      onPressed: validateAndSubmit,
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 70),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Giriş",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                    2,
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (BuildContext context)=>RegisterPage()));
                      },
                      child: Center(
                          child: Text(
                        "Hesabım Yok",
                        style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
   
  }
}
