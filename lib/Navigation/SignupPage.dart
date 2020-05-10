import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        addPhotoVoid();
      },
      child: Center(
        child: Container(
          //ANCHOR Mevcut size void'imizi kullandığımızda anlamsız bir height oluşuyor, çözemedim. Bundan ötürü normal ölçüleri kullandım burada:
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: MyColors().yellowContainer,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              height: heightSize(5),
              child: Image.asset(
                "assets/icons/addPhoto.png",
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nameSurname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: heightSize(8),
          width: widthSize(40),
          child: TextFormField(
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Ad*",
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
        Container(
          height: heightSize(8),
          width: widthSize(40),
          child: TextFormField(
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "Soyad*",
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
            hintText: "Email*",
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
          height: heightSize(3),
        ),
        TextFormField(
          obscureText: true,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Şifre*",
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

  Widget telephoneNumber() {
    return TextFormField(
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Telefon Numarası",
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
    );
  }

  Widget countryAndBirthDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: widthSize(43),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().yellowContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: DropdownButton<String>(
              hint: Text(
                ("Şehir"),
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
              items: [
                DropdownMenuItem(
                  child: Text("Adana merkez"),
                ),
              ],
              onChanged: (String selected) {},
            ),
          ),
        ),
        Container(
          width: widthSize(43),
          height: heightSize(8),
          decoration: new BoxDecoration(
            color: MyColors().yellowContainer,
            borderRadius: new BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Center(
            child: Text(
              "01.01.2020",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: heightSize(2),
                color: MyColors().whiteTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget selectGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            menVoid();
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: new BoxDecoration(
              color: menColor(),
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                ("Erkek"),
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            womenVoid();
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: new BoxDecoration(
              color: womenColor(),
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Kadın",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButton() {
    return InkWell(
      onTap: () {
        signUpVoid();
      },
      child: Container(
        width: widthSize(100),
        height: heightSize(8),
        decoration: new BoxDecoration(
          color: MyColors().purpleContainer,
          borderRadius: new BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            "KATILIMI TAMAMLA",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(2),
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            addPhoto(),
            SizedBox(
              height: heightSize(1),
            ),
            nameSurname(),
            SizedBox(
              height: heightSize(1),
            ),
            emailAndPasswordFields(),
            SizedBox(
              height: heightSize(1),
            ),
            telephoneNumber(),
            SizedBox(
              height: heightSize(2),
            ),
            countryAndBirthDate(),
            SizedBox(
              height: heightSize(2),
            ),
            selectGender(),
            SizedBox(
              height: heightSize(2),
            ),
            signUpButton(),
          ],
        ),
      ),
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

  void showPassword() {}

  void forgetPassword() {}

  void addPhotoVoid() {}

  void signUpVoid() {}

  //ANCHOR cinsiyet seçildikten sonra container'lar siyah olsun mu?
  menColor() {
    return MyColors().blueContainer;
  }

  womenColor() {
    return Colors.pinkAccent;
  }

  void womenVoid() {}

  void menVoid() {}
}
