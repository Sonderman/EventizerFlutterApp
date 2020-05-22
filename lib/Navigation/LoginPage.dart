import 'package:eventizer/Navigation/ExploreEventPage.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userId;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorText;
  bool _loading = false;
  bool visiblePassword = true;
  bool showLogin = false;
  String sendPasswordMailText = "Giriş";

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget welcomeText() {
    if (visiblePassword == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre Sıfırlama",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(4),
              color: MyColors().loginGreyColor,
            ),
          ),
          Text(
            "Mail Adresini Gir",
            style: TextStyle(
              height: heightSize(0.2),
              fontFamily: "ZonaLight",
              fontSize: heightSize(3.3),
              color: MyColors().greyTextColor,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tekrar Hoşgeldin",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(4),
              color: MyColors().loginGreyColor,
            ),
          ),
          Text(
            "Giriş yap ve devam et",
            style: TextStyle(
              height: heightSize(0.2),
              fontFamily: "ZonaLight",
              fontSize: heightSize(3.3),
              color: MyColors().greyTextColor,
            ),
          ),
        ],
      );
    }
  }

  Widget emailAndPasswordFields() {
    return Column(
      children: <Widget>[
        TextFormField(
          //onSaved: (value) => email = value,
          controller: email,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyColors().loginGreyColor),
            ),
          ),
          style: TextStyle(
            fontSize: heightSize(2.5),
            fontFamily: "ZonaLight",
            color: MyColors().loginGreyColor,
          ),
        ),
        Visibility(
          visible: showLogin,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: heightSize(2),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    rememberPass();
                  },
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().loginGreyColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: heightSize(5),
        ),
        passwordField(password),
      ],
    );
  }

  Widget passwordField(password) {
    bool showPassword = true;
    print("building custom stateful textfield password");
    return StatefulBuilder(
      builder: (context, state) {
        print("building internal state");
        return Visibility(
          visible: visiblePassword,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      //onSaved: (value) => password = value,
                      controller: password,
                      obscureText: showPassword,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        errorText: errorText,
                        errorStyle: TextStyle(
                          fontSize: heightSize(2),
                          fontFamily: "Zona",
                          color: Colors.red,
                        ),
                        border: InputBorder.none,
                        hintText: "Şifre",
                        hintStyle: TextStyle(
                          fontFamily: "Zona",
                          color: MyColors().loginGreyColor,
                        ),
                        alignLabelWithHint: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColors().loginGreyColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: MyColors().loginGreyColor),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: heightSize(2.5),
                        fontFamily: "ZonaLight",
                        color: MyColors().loginGreyColor,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: widthSize(12),
                      height: heightSize(6),
                      child: FlatButton(
                        child: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          state(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: heightSize(2),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    forgetPassword();
                  },
                  child: Text(
                    "Şifremi Unuttum",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().loginGreyColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget singInButton() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: FlatButton(
        color: MyColors().purpleContainer,
        highlightColor: MyColors().purpleContainerSplash,
        splashColor: MyColors().purpleContainerSplash,
        onPressed: () {
          if (visiblePassword == true) {
            setState(() {
              _loading = true;
            });
            loginButton(context);
          } else {
            debugPrint("mail gönderildi");
            passwordReset(context);
          }
        },
        child: Container(
          height: heightSize(8),
          //width: widthSize(90),
          alignment: Alignment.center,

          child: Text(
            sendPasswordMailText,
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(3),
              color: MyColors().whiteTextColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: heightSize(10),
                      ),
                      welcomeText(),
                      SizedBox(
                        height: heightSize(5),
                      ),
                      emailAndPasswordFields(),
                      Spacer(),
                      singInButton(),
                      SizedBox(
                        height: heightSize(5),
                      ),
                    ],
                  ),
                ),
              ] +
              (_loading ? [PageComponents().loadingOverlay(context, Colors.white)] : [])),
    );
  }

  //ANCHOR All Gestures are start here
  Future<void> loginButton(BuildContext context) async {
    var auth = AuthService.of(context).auth;
    userId = await auth.signIn(email.text, password.text);
    if (userId == null) {
      setState(() => _loading = false);
      Fluttertoast.showToast(msg: "Şifre veya Eposta yanlış!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 18.0);
    } else {
      if (await UserService(userId).updateSingleInfo("LastLoggedIn", "timeStamp")) {
        print('Signed in: $userId');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
      }
    }
  }

  void forgetPassword() {
    setState(() {
      visiblePassword = !visiblePassword;
      sendPasswordMailText = "Mail Gönder";
      showLogin = true;
    });
  }

  Future<void> passwordReset(BuildContext context) async {
    var auth = AuthService.of(context).auth;
    //ANCHOR release yaparken açılacak
    //auth.sendPasswordResetEmail(email.text);
    debugPrint("şifre sıfırlama maili gönderildi");
  }

  void rememberPass() {
    setState(() {
      if(visiblePassword == false) {
        sendPasswordMailText = "Giriş Yap";
        visiblePassword = true;
        showLogin = false;
      }
    });

  }
}
