import 'dart:io';
import 'dart:math';
import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  final PageController pageController;

  SignUpPage(this.pageController);

  //NOTE We should be just use the button of "Create Account" for navigation to "Create Account Page". Not with slide.
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  File _image;
  bool loading = false;
  String _name, _surname, _phoneNumber, _country, _birthday;
  bool _gender;
  bool showPassword = true;

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  // ANCHOR kameradan foto almaya yarar
  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _image = image;
    });
  }

// ANCHOR galeriden foto almaya yarar
  Future _getImageFromGalery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: heightSize(5),
                  ),
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
                  SizedBox(
                    height: heightSize(2),
                  ),
                ],
              ),
            ),
          );
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Bir Seçim Yapınız',
              style: TextStyle(
                fontSize: heightSize(2.5),
                fontFamily: "Zona",
                color: MyColors().loginGreyColor,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                      child: Text(
                        'Galeri',
                        style: TextStyle(
                          fontSize: heightSize(2),
                          fontFamily: "ZonaLight",
                          color: MyColors().loginGreyColor,
                        ),
                      ),
                      onTap: () {
                        _getImageFromGalery().whenComplete(() {
                          Navigator.pop(context);
                        });
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text(
                        'Kamera',
                        style: TextStyle(
                          fontSize: heightSize(2),
                          fontFamily: "ZonaLight",
                          color: MyColors().loginGreyColor,
                        ),
                      ),
                      onTap: () {
                        _getImageFromCamera().whenComplete(() {
                          Navigator.pop(context);
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }

  String generateNickName(String name) {
    return name + (1 + Random().nextInt(9998)).toString();
  }

  void signUp() async {
    //ANCHOR Veritabanına kaydetmek için
    List<String> datalist = [
      _name,
      _surname,
      mailController.text,
      _phoneNumber,
      _gender ? "Man" : "Woman",
      _country,
      _birthday,
      generateNickName(_name)
    ];
    print(datalist);
    try {
      await Provider.of<UserService>(context, listen: false)
          .registerUser(
              mailController.text, passwordController.text, datalist, _image)
          .then((userID) {
        if (userID != null) {
          print("Upload işlemi bitti");

          Fluttertoast.showToast(
              msg: "Hesabınız başarıyla oluşturuldu.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 18.0);

          Provider.of<UserService>(context, listen: false)
              .userInitializer(userID)
              .then((value) {
            if (value)
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage()));
          });
        } else {
          setState(() {
            loading = false;
            print("Sign Up Failed!");
          });
        }
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
        print("Sign Up Failed!");
      });
    }
  }

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: Container(
        width: widthSize(30),
        height: widthSize(30),
        /*
        decoration: BoxDecoration(
          color: MyColors().orangeContainer,
          shape: BoxShape.circle,
        ),*/
        child: CircleAvatar(
          backgroundColor: MyColors().orangeContainer,
          radius: 100,
          child: _image == null
              ? Image.asset(
                  'assets/images/add-user.png',
                  height: heightSize(5),
                )
              : ClipOval(
                  child: Image.file(
                    _image,
                    width: widthSize(30),
                    height: widthSize(30),
                    fit: BoxFit.cover,
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
            onChanged: (ad) => _name = ad,
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
            onChanged: (soyad) => _surname = soyad,
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
          controller: mailController,
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
          controller: passwordController,
          obscureText: showPassword,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Şifre*",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            suffixIcon: FlatButton(
              child:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
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
          controller: password2Controller,
          obscureText: showPassword,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Şifre Tekrar*",
            hintStyle: TextStyle(
              fontFamily: "Zona",
              color: MyColors().loginGreyColor,
            ),
            alignLabelWithHint: true,
            suffixIcon: FlatButton(
              child:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
            ),
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
      ],
    );
  }

  Widget telephoneNumber() {
    return TextFormField(
      onChanged: (phone) => _phoneNumber = phone,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.number,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      maxLength: 10,
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
                _country != null ? _country : ("Ülke Seçin"),
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2),
                  color: MyColors().whiteTextColor,
                ),
              ),
              items: [
                DropdownMenuItem(
                  child: Text("Türkiye"),
                  value: "TR",
                ),
                DropdownMenuItem(
                  child: Text("United States"),
                  value: "US",
                ),
                DropdownMenuItem(
                  child: Text("United Kingdom"),
                  value: "UK",
                ),
              ],
              onChanged: (country) {
                setState(() {
                  _country = country;
                });
              },
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            final datePick = await showDatePicker(
                context: context,
                initialDate: DateTime(DateTime.now().year - 18),
                firstDate: DateTime(DateTime.now().year - 70),
                lastDate: DateTime(DateTime.now().year - 18));
            if (datePick != null) {
              setState(() {
                _birthday =
                    "${datePick.day}/${datePick.month}/${datePick.year}";
              });
            }
          },
          child: Container(
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
                _birthday != null ? _birthday : "Doğum Tarihiniz",
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

  Widget selectGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              _gender = true;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: new BoxDecoration(
              color: _gender != null
                  ? _gender ? Colors.black : menColor()
                  : menColor(),
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
            setState(() {
              _gender = false;
            });
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(5),
            decoration: new BoxDecoration(
              color: _gender != null
                  ? _gender ? womenColor() : Colors.black
                  : womenColor(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FlatButton(
            color: MyColors().purpleContainer,
            highlightColor: MyColors().purpleContainerSplash,
            splashColor: MyColors().purpleContainerSplash,
            onPressed: () {
              widget.pageController.previousPage(
                  duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
            },
            child: Container(
              height: heightSize(8),
              width: widthSize(35),
              alignment: Alignment.center,
              child: Text(
                "Hesabım Var",
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
          onTap: () async {
            //ANCHOR veri kontrolleri burda
            if (_image != null &&
                _name != null &&
                _surname != null &&
                mailController.text != null &&
                passwordController.text != null &&
                passwordController.text == password2Controller.text &&
                _gender != null &&
                _birthday != null &&
                _country != null) {
              setState(() {
                loading = true;
              });
              signUp();
            } else {
              Fluttertoast.showToast(
                  msg: "Lütfen Girdileri Kontrol Ediniz!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 3,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 18.0);
            }
          },
          child: Container(
            width: widthSize(43),
            height: heightSize(8),
            decoration: new BoxDecoration(
              color: MyColors().purpleContainer,
              borderRadius: new BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Center(
              child: Text(
                "Hesabı Oluştur",
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

  //ANCHOR cinsiyet seçildikten sonra container'lar siyah olsun mu?
  menColor() {
    return MyColors().blueContainer;
  }

  womenColor() {
    return Colors.pinkAccent;
  }
}
