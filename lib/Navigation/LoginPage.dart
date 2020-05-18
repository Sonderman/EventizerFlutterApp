import 'package:eventizer/Navigation/ExploreEventPage.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userId;
  String email;
  String password;
  String errorText;

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget welcomeText() {
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

  Widget emailAndPasswordFields() {
    return Column(
      children: <Widget>[
        TextFormField(
          onSaved: (value) => email = value,
          //controller: mail,
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
        SizedBox(
          height: heightSize(5),
        ),
        buildPasswordField(password),
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
    );
  }

  Widget buildPasswordField(password) {
    bool showPassword = false;
    print("building custom stateful textfield password");
    return StatefulBuilder(
      builder: (context, fn) {
        print("building internal state");
        return Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                onSaved: (value) => password = value,
                //controller: password,
                obscureText: !showPassword,
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
                  onPressed: () {
                    showPassword = !showPassword;
                    fn(() {});
                  },
                ),
              ),
            ),
          ],
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
          loginButton(context, email, password);
        },
        child: Container(
          height: heightSize(8),
          //width: widthSize(90),
          alignment: Alignment.center,

          child: Text(
            "Giriş",
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
      body: Padding(
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
    );
  }

  //ANCHOR All Gestures are start here
  Future<void> loginButton(BuildContext context, email, password) async {
    var auth = AuthService.of(context).auth;
    userId = await auth.signIn(email, password).whenComplete(
          () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ExploreEventPage())),
        );
  }

  void forgetPassword() {}
}
