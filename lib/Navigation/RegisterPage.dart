import 'dart:async';
import 'dart:io';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Navigation/Old/OldLoginPage.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/animations/FadeAnimation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage2 extends StatefulWidget {
  RegisterPage2({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage2> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  bool loading = false;
  String _ad;
  String _soyad;
  String _eposta;
  String _sifre;

  LoginAndRegister loginAndRegister = LoginAndRegister();

  void _validationToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  bool _validateAndSubmit() {
    if (_image == null) {
      print("Profil Fotoğrafı seçilmedi!");
      _validationToastMessage("Profil Fotoğrafı seçilmedi!");
      return false;
    } else
      return true;
  }

// ANCHOR kameradan foto almaya yarar
  Future _getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
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

  // ANCHOR bu fonksiyon kullanici profil fotosuna bastiginda bir dialog olusturur
  // ANCHOR bu dialogda galeri ve kamera secenekleri vererek kullanicinin foto eklemesini saglar
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bir Seçim Yapınız'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                      child: Text('Galeri'),
                      onTap: () {
                        _getImageFromGalery().whenComplete(() {
                          Navigator.pop(context);
                        });
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Kamera'),
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

  void validationToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  void signUp() async {
    // ANCHOR Kullanici kayit olana kadar loading kismini gosterecek
    setState(() {
      loading = true;
    });
    //ANCHOR Veritabanına kaydetmek için
    List<String> datalist = [
      _ad,
      _soyad,
      _eposta,
    ];
    print(datalist);
    await loginAndRegister
        .registerUser(context, _eposta, _sifre, datalist, _image)
        .whenComplete(() {
      emailVerifyToastMessage();
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
      });
    }).catchError((error) {
      print(error);
      Fluttertoast.showToast(
          msg: "Girdileri gözden geçiriniz!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      setState(() {
        loading = false;
      });
    });
  }

  void emailVerifyToastMessage() {
    Fluttertoast.showToast(
        msg: "Doğrulama maili gönderildi.Lütfen mailinizi doğrulayınız!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: Colors.cyan,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 250,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: -40,
                          height: 250,
                          width: width,
                          child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/background.png'),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                        Positioned(
                          height: 250,
                          width: width + 20,
                          child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/background-2.png'),
                                      fit: BoxFit.fill)),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 30,
                            top: 90,
                            height: 100,
                            width: 100,
                            child: GestureDetector(
                              onTap: () {
                                _showChoiceDialog(context);
                              },
                              child: FadeAnimation(
                                1.4,
                                ClipOval(
                                    child: FadeInImage(
                                        placeholder: AssetImage(
                                            'assets/images/add-user.png'),
                                        image: _image == null
                                            ? AssetImage(
                                                'assets/images/add-user.png')
                                            : FileImage(_image))),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          FadeAnimation(
                            1.5,
                            Text(
                              "Kayıt Ol",
                              style: TextStyle(
                                  color: Color.fromRGBO(49, 39, 79, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30),
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
                                    )
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Adınız",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      validator: (value) => value.isEmpty
                                          ? 'Ad boş olamaz'
                                          : null,
                                      onSaved: (value) => _ad = value,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Soyadınız",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      validator: (value) => value.isEmpty
                                          ? 'Soyad boş olamaz'
                                          : null,
                                      onSaved: (value) => _soyad = value,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    padding: EdgeInsets.all(5),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Eposta",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      validator: (value) => value.isEmpty
                                          ? 'Eposta boş olamaz'
                                          : null,
                                      onSaved: (value) => _eposta = value,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey[200]))),
                                    padding: EdgeInsets.all(5),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      validator: (value) => value.isEmpty
                                          ? 'Şifre boş olamaz'
                                          : null,
                                      onSaved: (value) => _sifre = value,
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
                            1.9,
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginPage()));
                              },
                              child: Center(
                                  child: Text(
                                "Hesabım var?",
                                style: TextStyle(
                                    color: Color.fromRGBO(196, 135, 198, 1)),
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                            2,
                            Material(
                              child: MaterialButton(
                                onPressed: () {
                                  if (_validateAndSubmit() &&
                                      _formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    signUp();
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  margin: EdgeInsets.symmetric(horizontal: 60),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color.fromRGBO(49, 39, 79, 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Kayıt ol",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
