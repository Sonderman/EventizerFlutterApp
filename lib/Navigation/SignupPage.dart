import 'dart:io';

import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  final PageController pageController;

  SignupPage(this.pageController);
  //NOTE We should be just use the button of "Create Account" for navigation to "Create Account Page". Not with slide.
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  LoginAndRegister loginAndRegister = LoginAndRegister();
  File _image;
  bool loading = false;
  String _name, _surname, _phonenumber, _country, _birthday;
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

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Bir Seçim Yapınız',
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
                      child: Text('Galeri',
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
                      child: Text('Kamera',
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

  void signUp() async {
    // ANCHOR Kullanici kayit olana kadar loading kismini gosterecek
    setState(() {
      loading = true;
    });
    //ANCHOR Veritabanına kaydetmek için
    List<String> datalist = [_name, _surname, mailController.text, _phonenumber, _gender ? "Man" : "Woman", _country, _birthday];
    print(datalist);
    await loginAndRegister.registerUser(context, mailController.text, passwordController.text, datalist, _image).whenComplete(() {
      Fluttertoast.showToast(msg: "Doğrulama maili gönderildi.Lütfen mailinizi doğrulayınız!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, backgroundColor: Colors.cyan, textColor: Colors.white, fontSize: 18.0);
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
      });
    }).catchError((error) {
      print(error);
      Fluttertoast.showToast(msg: "Girdileri gözden geçiriniz!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 2, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 18.0);
      setState(() {
        loading = false;
      });
    });
  }

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: Container(
        //ANCHOR Mevcut size void'imizi kullandığımızda anlamsız bir height oluşuyor, çözemedim. Bundan ötürü normal ölçüleri kullandım burada:
        // NOTE Fixed.
        height: heightSize(20),
        decoration: BoxDecoration(
          color: MyColors().yellowContainer,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Container(
            height: heightSize(5),
            child: _image == null ? Image.asset('assets/images/add-user.png') : Image.file(_image),
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
              child: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
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
      onChanged: (phone) => _phonenumber = phone,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.number,
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
            final datePick = await showDatePicker(context: context, initialDate: DateTime(DateTime.now().year - 18), firstDate: DateTime(DateTime.now().year - 70), lastDate: DateTime(DateTime.now().year - 18));
            if (datePick != null) {
              setState(() {
                _birthday = "${datePick.day}/${datePick.month}/${datePick.year}";
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
              color: _gender != null ? _gender ? Colors.black : menColor() : menColor(),
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
              color: _gender != null ? _gender ? womenColor() : Colors.black : womenColor(),
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
              widget.pageController.previousPage(duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
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
          onTap: () {
            //ANCHOR veri kontrolleri burda
            if (_image != null && _name != null && _surname != null && mailController.text != null && passwordController.text != null && _gender != null && _birthday != null && _country != null) {
              signUp();
              setState(() {
                loading = true;
              });
            } else {
              Fluttertoast.showToast(msg: "Lütfen Girdileri Kontrol Ediniz!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM, timeInSecForIosWeb: 3, backgroundColor: Colors.red, textColor: Colors.white, fontSize: 18.0);
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

  //ANCHOR cinsiyet seçildikten sonra container'lar siyah olsun mu?
  menColor() {
    return MyColors().blueContainer;
  }

  womenColor() {
    return Colors.pinkAccent;
  }
}
