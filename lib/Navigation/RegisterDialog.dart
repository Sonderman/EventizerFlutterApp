import 'dart:io';
import 'package:eventizer/Services/AuthProvider.dart';
import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eventizer/assets/Sehirler.dart';
import 'package:image_picker/image_picker.dart';

class RegisterDialog extends StatefulWidget {
  RegisterDialog({Key key}) : super(key: key);

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  String _ad;
  String _soyad;
  String _eposta;
  String _sifre;
  String _dogumtarihi;
  String _sehir;
  String _cinsiyet;

  bool isDateSelected = false;
  DateTime birthDate;

  int genderIndex = 0;
  MaterialColor maleGenderColor = Colors.blue;
  MaterialColor femaleGenderColor = Colors.blue;

  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

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
      switch (genderIndex) {
        case 0:
          print('Error:Cinsiyet secilmedi!');
          break;
        case 1:
          _cinsiyet = "Erkek";
          break;
        case 2:
          _cinsiyet = "Kadın";
          break;
      }
      var auth = AuthProvider.of(context).auth;
      String userId = "test";
      userId = await auth.signUp(_eposta, _sifre);
      //auth.sendEmailVerification();
      emailVerifyToastMessage();
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
        print(
            'Signed in: $userId\nAd:$_ad\nSoyad:$_soyad\nEposta:$_eposta\nSifre:$_sifre\nCinsiyet:$_cinsiyet\nDoğum Tarihi:$_dogumtarihi\nŞehir:$_sehir');
        Future.delayed(const Duration(milliseconds: 2100), () {
          //Navigator.pushReplacement(context,
          // MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
        });
      }
    }
  }

  void emailVerifyToastMessage() {
    Fluttertoast.showToast(
        msg: "Doğrulama maili gönderildi.Lütfen mailinizi doğrulayınız!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.cyan,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        color: Colors.black54,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                GestureDetector(
                    onTap: getImage,
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(75.0),
                          child: _image == null
                              ? Text('No image selected.')
                              : Image.file(_image)),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Bir profil resmi seçiniz',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ),
                Card(
                  //margin: EdgeInsets.all(10.0),
                  elevation: 8.0,
                  child: Container(
                    child: Form(
                        key: formkey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Adınız'),
                                validator: (value) =>
                                    value.isEmpty ? 'Ad boş olamaz' : null,
                                onSaved: (value) => _ad = value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Soyadınız'),
                                validator: (value) =>
                                    value.isEmpty ? 'Soyad boş olamaz' : null,
                                onSaved: (value) => _soyad = value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'Eposta'),
                                validator: (value) =>
                                    value.isEmpty ? 'Eposta boş olamaz' : null,
                                onSaved: (value) => _eposta = value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Şifre'),
                                validator: (value) =>
                                    value.isEmpty ? 'Şifre boş olamaz' : null,
                                onSaved: (value) => _sifre = value,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Cinsiyetinizi Seçiniz',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.male,
                                    color: maleGenderColor,
                                  ),
                                  onPressed: () {
                                    genderIndex = 1;
                                    setState(() {
                                      if (maleGenderColor == Colors.green) {
                                        maleGenderColor = Colors.blue;
                                        femaleGenderColor = Colors.green;
                                      } else {
                                        maleGenderColor = Colors.green;
                                        femaleGenderColor = Colors.blue;
                                      }
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.female,
                                    color: femaleGenderColor,
                                  ),
                                  onPressed: () {
                                    genderIndex = 2;
                                    setState(() {
                                      if (femaleGenderColor == Colors.green) {
                                        femaleGenderColor = Colors.blue;
                                        maleGenderColor = Colors.green;
                                      } else {
                                        femaleGenderColor = Colors.green;
                                        maleGenderColor = Colors.blue;
                                      }
                                    });
                                  },
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Doğum Tarihinizi Seçiniz',
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                            GestureDetector(
                                child: new Icon(Icons.date_range),
                                onTap: () async {
                                  final datePick = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime(DateTime.now().year - 18),
                                      firstDate: DateTime(1900),
                                      lastDate:
                                          DateTime(DateTime.now().year - 18));
                                  if (datePick != null &&
                                      datePick != birthDate) {
                                    setState(() {
                                      birthDate = datePick;
                                      isDateSelected = true;
                                      _dogumtarihi =
                                          "${birthDate.day}/${birthDate.month}/${birthDate.year}";
                                    });
                                  }
                                }),
                            FindDropdown(
                              items: Sehirler().sehirler,
                              onChanged: (String item) {
                                setState(() {
                                  _sehir = item;
                                });
                              },
                              selectedItem: "Şehir Seçiniz",
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(30.0),
                              //elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: validateAndSubmit,
                                  minWidth: 150.0,
                                  height: 50.0,
                                  color: Color(0xFF179CDF),
                                  child: Text(
                                    "Kayıt Ol",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
