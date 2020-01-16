import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_panel/flutter_search_panel.dart';
import 'package:flutter_search_panel/search_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eventizer/assets/Sehirler.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  LoginAndRegister loginAndRegister = LoginAndRegister();
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

  bool progressIndicator = false;

  File _image;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  Future getImageFromGalery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
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

  bool validateAndSubmit() {
    if (validateAndSave()) {
      switch (genderIndex) {
        case 0:
          print('Error:Cinsiyet secilmedi!');
          validationToastMessage("Cinsiyet seçilmedi!");
          return false;
          break;
        case 1:
          _cinsiyet = "Erkek";
          break;
        case 2:
          _cinsiyet = "Kadın";
          break;
      }
    }
    if (!isDateSelected) {
      print("Doğum tarihi seçilmedi!");
      validationToastMessage("Doğum tarihi seçilmedi!");
      return false;
    } else if (_image == null) {
      print("Profil Fotoğrafı seçilmedi!");
      validationToastMessage("Profil Fotoğrafı seçilmedi!");
      return false;
    } else if (_sehir == null) {
      print("Sehir seçilmedi!");
      validationToastMessage("Sehir seçilmedi!");
      return false;
    } else
      return true;
  }

  void validationToastMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 18.0);
  }

  void signUp() async {
    List<String> datalist = [
      _ad,
      _soyad,
      _eposta,
      _cinsiyet,
      _dogumtarihi,
      _sehir,
    ];

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
          timeInSecForIos: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
      setState(() {
        progressIndicator = false;
      });
    });
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

  void createTestUser() {
    setState(() {
      progressIndicator = true;
    });
    getImageFromGalery().then((onValue) {}).whenComplete(() {
      var auth = AuthService.of(context).auth;
      String userId, url;
      auth.signUp("test@test.com", "123123").then((value) {
        userId = value;
        if (userId != null) {
          Firestore.instance.collection('users').document(userId).setData({
            "Name": "TestName",
            "Surname": "TestSurname",
            "Email": "test@test.com",
            "Gender": "Erkek",
            "Birthday": "01/01/2001",
            "City": "Çorum",
            "RegisteredAt": FieldValue.serverTimestamp()
          }).whenComplete(() {
            StorageReference storageReference = FirebaseStorage()
                .ref()
                .child('users')
                .child(userId)
                .child('images')
                .child('profile')
                .child('ProfileImage');
            StorageUploadTask uploadTask = storageReference.putFile(_image);
            StreamSubscription<StorageTaskEvent> streamSubscription =
                uploadTask.events.listen((event) {
              print('UploadingProfile Image :${event.type}');
            });

            uploadTask.onComplete.then((onValue) {
              onValue.ref.getDownloadURL().then((value) {
                url = value.toString();
                print("Url:" + url);
              }).whenComplete(() {
                Firestore.instance
                    .collection('users')
                    .document(userId)
                    .updateData({"ProfilePhotoUrl": url});
              });
            }).whenComplete(() {
              streamSubscription.cancel();
              Future.delayed(const Duration(milliseconds: 200), () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AuthCheck()));
              });
            });

            print('Başarılı: TestUser oluşturuldu.');
          }).catchError((e) {
            print(e);
          });
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => AuthCheck()));
        }
      }, onError: (e) {
        print('ERROR:Kayıt olurken hata!: $e');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return progressIndicator == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 7.0,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey,
            appBar: AppBar(
              //backgroundColor: Colors.red,
              elevation: 2.0,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MaterialButton(
                              onPressed: () {
                                setState(() {
                                  progressIndicator = true;
                                });
                                createTestUser();
                              },
                              height: 25.0,
                              color: Color(0xFF179CDF),
                              child: Text(
                                "TestUserOluştur",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      containerGetProfileImage(),
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
                      cardFormFields(context)
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Card cardFormFields(BuildContext context) {
    List<SearchItem<int>> sehirler = [];
    for (int i = 1; i <= 81; i++) {
      sehirler.add(SearchItem(i, Sehirler().sehirler[i - 1]));
    }
    return Card(
      elevation: 8.0,
      child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Adınız'),
                  validator: (value) => value.isEmpty ? 'Ad boş olamaz' : null,
                  onSaved: (value) => _ad = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Soyadınız'),
                  validator: (value) =>
                      value.isEmpty ? 'Soyad boş olamaz' : null,
                  onSaved: (value) => _soyad = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Eposta'),
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
                  obscureText: true,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Cinsiyetinizi Seçiniz:',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Doğum Tarihinizi Seçiniz:',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                  GestureDetector(
                      child: new Icon(Icons.date_range),
                      onTap: () async {
                        final datePick = await showDatePicker(
                            context: context,
                            initialDate: DateTime(DateTime.now().year - 18),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(DateTime.now().year - 18));
                        if (datePick != null && datePick != birthDate) {
                          setState(() {
                            birthDate = datePick;
                            isDateSelected = true;
                            _dogumtarihi =
                                "${birthDate.day}/${birthDate.month}/${birthDate.year}";
                          });
                        }
                      }),
                ],
              ),
              /*FindDropdown(
                items: Sehirler().sehirler,
                onChanged: (String item) {
                  setState(() {
                    _sehir = item;
                  });
                },
                selectedItem: "Şehir Seçiniz",
              ),*/
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Şehir Seçiniz:"),
                  SizedBox(
                    width: 25,
                  ),
                  FlutterSearchPanel<int>(
                    selected: 1,
                    title: "Şehir Seçiniz",
                    data: sehirler,
                    icon: Icon(Icons.check_circle, color: Colors.white),
                    color: Colors.red,
                    textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0,
                        decorationStyle: TextDecorationStyle.dotted),
                    onChanged: (int item) {
                      _sehir = Sehirler().sehirler[item - 1];
                    },
                  ),
                ],
              ),
              Material(
                borderRadius: BorderRadius.circular(30.0),
                //elevation: 5.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () {
                      if (validateAndSubmit()) {
                        signUp();
                        setState(() {
                          progressIndicator = true;
                        });
                      }
                    },
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
    );
  }

  Row containerGetProfileImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
            onTap: getImageFromCamera,
            child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(120.0),
                ),
                child: Icon(FontAwesomeIcons.camera))),
        GestureDetector(
            child: Container(
          width: 175.0,
          height: 175.0,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage('assets/images/user.png'),
                fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(120.0),
            /*border: Border.all(
                            width: 3.0,
                            color: Colors.red,
                          ),*/
          ),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(120.0),
              child: _image == null
                  ? null //Text('Resim seçilmedi!.')
                  : Image.file(_image)),
        )),
        GestureDetector(
            onTap: getImageFromGalery,
            child: Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(120.0),
                  /*border: Border.all(
                            width: 3.0,
                            color: Colors.red,
                          ),*/
                ),
                child: Icon(FontAwesomeIcons.images)))
      ],
    );
  }
}
