import 'dart:async';
import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/animations/FadeAnimation.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_search_panel/flutter_search_panel.dart';
// import 'package:flutter_search_panel/search_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  bool progressIndicator = false;
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
        timeInSecForIos: 2,
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
                        _getImageFromGalery();
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Kamera'),
                      onTap: () {
                        _getImageFromCamera();
                      }),
                ],
              ),
            ),
          );
        });
  }

// ANCHOR Kullanici profiline bir foto eklediginde sayfamizdaki default photomuz
// ANCHOR kullanicinin ekledigi photo ile degisir
  Widget _buildChild() {
    if (_image == null) {
      return Image(image: AssetImage('assets/images/add-user.png'));
    }
    return Image.file(_image);
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return progressIndicator == true
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                strokeWidth: 7.0,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                            left: width / 2 - 20,
                            top: 80,
                            height: 70,
                            width: 70,
                            child: GestureDetector(
                              onTap: () {
                                _showChoiceDialog(context);
                              },
                              child: FadeAnimation(
                                1.4,
                                ClipOval(
                                  child: _buildChild(),
                                ),
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
                            MaterialButton(
                              onPressed: () {
                                if (_validateAndSubmit()) {
                                  signUp();
                                  setState(() {
                                    progressIndicator = true;
                                  });
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

//      progressIndicator == true
//         ? Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(
//                 strokeWidth: 7.0,
//               ),
//             ),
//           )
//         : Scaffold(
//             backgroundColor: Colors.grey,
//             appBar: AppBar(
//               //backgroundColor: Colors.red,
//               elevation: 2.0,
//               title: Text('Kayıt Ol'),
//               centerTitle: true,
//             ),
//             body: Container(
//               padding: EdgeInsets.all(16.0),
//               color: Colors.black54,
//               child: SingleChildScrollView(
//                 child: Center(
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: MaterialButton(
//                               onPressed: () {
//                                 setState(() {
//                                   progressIndicator = true;
//                                 });
//                                 createTestUser();
//                               },
//                               height: 25.0,
//                               color: Color(0xFF179CDF),
//                               child: Text(
//                                 "TestUserOluştur",
//                                 style: TextStyle(
//                                   fontSize: 12.0,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                       containerGetProfileImage(),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           'Bir profil resmi seçiniz',
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       cardFormFields(context)
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//   }

//   Card cardFormFields(BuildContext context) {
//     List<SearchItem<int>> sehirler = [];
//     for (int i = 1; i <= 81; i++) {
//       sehirler.add(SearchItem(i, Sehirler().sehirler[i - 1]));
//     }
//     return Card(
//       elevation: 8.0,
//       child: Form(
//           key: formkey,
//           child: Column(
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(labelText: 'Adınız'),
//                   validator: (value) => value.isEmpty ? 'Ad boş olamaz' : null,
//                   onSaved: (value) => _ad = value,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(labelText: 'Soyadınız'),
//                   validator: (value) =>
//                       value.isEmpty ? 'Soyad boş olamaz' : null,
//                   onSaved: (value) => _soyad = value,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(labelText: 'Eposta'),
//                   validator: (value) =>
//                       value.isEmpty ? 'Eposta boş olamaz' : null,
//                   onSaved: (value) => _eposta = value,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   decoration: InputDecoration(labelText: 'Şifre'),
//                   validator: (value) =>
//                       value.isEmpty ? 'Şifre boş olamaz' : null,
//                   onSaved: (value) => _sifre = value,
//                   obscureText: true,
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Cinsiyetinizi Seçiniz:',
//                       style: TextStyle(fontSize: 15.0),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       FontAwesomeIcons.male,
//                       color: maleGenderColor,
//                     ),
//                     onPressed: () {
//                       genderIndex = 1;
//                       setState(() {
//                         if (maleGenderColor == Colors.green) {
//                           maleGenderColor = Colors.blue;
//                           femaleGenderColor = Colors.green;
//                         } else {
//                           maleGenderColor = Colors.green;
//                           femaleGenderColor = Colors.blue;
//                         }
//                       });
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       FontAwesomeIcons.female,
//                       color: femaleGenderColor,
//                     ),
//                     onPressed: () {
//                       genderIndex = 2;
//                       setState(() {
//                         if (femaleGenderColor == Colors.green) {
//                           femaleGenderColor = Colors.blue;
//                           maleGenderColor = Colors.green;
//                         } else {
//                           femaleGenderColor = Colors.green;
//                           maleGenderColor = Colors.blue;
//                         }
//                       });
//                     },
//                   )
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(
//                       'Doğum Tarihinizi Seçiniz:',
//                       style: TextStyle(fontSize: 15.0),
//                     ),
//                   ),
//                   GestureDetector(
//                       child: Icon(Icons.date_range),
//                       onTap: () async {
//                         final datePick = await showDatePicker(
//                             context: context,
//                             initialDate: DateTime(DateTime.now().year - 18),
//                             firstDate: DateTime(1900),
//                             lastDate: DateTime(DateTime.now().year - 18));
//                         if (datePick != null && datePick != birthDate) {
//                           setState(() {
//                             birthDate = datePick;
//                             isDateSelected = true;
//                             _dogumtarihi =
//                                 "${birthDate.day}/${birthDate.month}/${birthDate.year}";
//                           });
//                         }
//                       }),
//                 ],
//               ),
//               /*FindDropdown(
//                 items: Sehirler().sehirler,
//                 onChanged: (String item) {
//                   setState(() {
//                     _sehir = item;
//                   });
//                 },
//                 selectedItem: "Şehir Seçiniz",
//               ),*/
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text("Şehir Seçiniz:"),
//                   SizedBox(
//                     width: 25,
//                   ),
//                   FlutterSearchPanel<int>(
//                     selected: 1,
//                     title: "Şehir Seçiniz",
//                     data: sehirler,
//                     icon: Icon(Icons.check_circle, color: Colors.white),
//                     color: Colors.red,
//                     textStyle: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12.0,
//                         decorationStyle: TextDecorationStyle.dotted),
//                     onChanged: (int item) {
//                       _sehir = Sehirler().sehirler[item - 1];
//                     },
//                   ),
//                 ],
//               ),
//               Material(
//                 borderRadius: BorderRadius.circular(30.0),
//                 //elevation: 5.0,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: MaterialButton(
//                     onPressed: () {
//                       if (validateAndSubmit()) {
//                         signUp();
//                         setState(() {
//                           progressIndicator = true;
//                         });
//                       }
//                     },
//                     minWidth: 150.0,
//                     height: 50.0,
//                     color: Color(0xFF179CDF),
//                     child: Text(
//                       "Kayıt Ol",
//                       style: TextStyle(
//                         fontSize: 16.0,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//             ],
//           )),
//     );
//   }

//   Row containerGetProfileImage() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: <Widget>[
//         GestureDetector(
//             onTap: getImageFromCamera,
//             child: Container(
//                 width: 50.0,
//                 height: 50.0,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(120.0),
//                 ),
//                 child: Icon(FontAwesomeIcons.camera))),
//         GestureDetector(
//             child: Container(
//           width: 175.0,
//           height: 175.0,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//                 image: ExactAssetImage('assets/images/user.png'),
//                 fit: BoxFit.fill),
//             borderRadius: BorderRadius.circular(120.0),
//             /*border: Border.all(
//                             width: 3.0,
//                             color: Colors.red,
//                           ),*/
//           ),
//           child: ClipRRect(
//               borderRadius: BorderRadius.circular(120.0),
//               child: _image == null
//                   ? null //Text('Resim seçilmedi!.')
//                   : Image.file(_image)),
//         )),
//         GestureDetector(
//             onTap: getImageFromGalery,
//             child: Container(
//                 width: 50.0,
//                 height: 50.0,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(120.0),
//                   /*border: Border.all(
//                             width: 3.0,
//                             color: Colors.red,
//                           ),*/
//                 ),
//                 child: Icon(FontAwesomeIcons.images)))
//       ],
//     );
//   }
// }
