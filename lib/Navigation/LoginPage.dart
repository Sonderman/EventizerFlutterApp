import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery
        .of(context)
        .size
        .height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery
        .of(context)
        .size
        .width * value;
  }

  Widget welcomeText() {
    return Column(
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
        TextFormField(
          obscureText: true,
          textAlign: TextAlign.left,
          decoration: InputDecoration(

            border: InputBorder.none,
            hintText: "Şifre",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            suffixIcon: showPasswordIcon(),
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

  Widget showPasswordIcon() {
    return GestureDetector(
      onTap: () {
        showPassword();

      },
      child: Icon(
        Icons.remove_red_eye,
        color: MyColors().greyTextColor,
      ),
    );
  }

  Widget singInButton() {
    return GestureDetector(
      onTap: () {
        loginButton();
      },
      child: Container(
        height: heightSize(8),
        width: widthSize(90),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: MyColors().purpleContainer,
          borderRadius: new BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Text(
          "Giriş",
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: heightSize(3),
            color: MyColors().whiteTextColor,
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
  void loginButton() {}
  void showPassword() {}
  void forgetPassword() {}

}
