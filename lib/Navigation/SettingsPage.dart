import 'dart:io';
import 'package:eventizer/Services/AuthCheck.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/assets/Sehirler.dart';
import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_panel/flutter_search_panel.dart';
import 'package:flutter_search_panel/search_item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controllerAd;
  TextEditingController controllerSoyad;
  TextEditingController controllerTelNo;

  bool triggerToast = false;

  void _signedOut() {
    var auth = AuthService.of(context).auth;
    auth.signOut();
    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) => AuthCheck()));
  }

  @override
  Widget build(BuildContext context) {
    var userWorker = Provider.of<UserService>(context);
    return Scaffold(
      backgroundColor: MyColors().blueThemeColor,
      appBar: AppBar(
        title: Text("Ayarlar"),
        backgroundColor: MyColors().blueThemeColor,
        centerTitle: true,
        actions: <Widget>[
          Card(
            color: Colors.red,
            child: IconButton(
                icon: Icon(FontAwesomeIcons.signOutAlt), onPressed: _signedOut),
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.user),
                    label: Text('Kişisel bilgileri düzenle'),
                    onPressed: () {
                      triggerToast = false;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return updateMyPersonalInfoDialog(userWorker);
                          }).whenComplete(() {
                        if (triggerToast) {
                          userWorker.userModelUpdater(
                              userWorker.usermodel.getUserId());
                          Fluttertoast.showToast(
                              msg: "Kişisel bilgileriniz Güncellendi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 18.0);
                        }
                      });
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    height: 1,
                  ),
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.envelope),
                    label: Text('Email adresini güncelle'),
                    onPressed: () {
                      triggerToast = false;
                      showDialog(
                          context: context,
                          builder: (context) {
                            return myChangeEmailDialog(userWorker);
                          }).whenComplete(() {
                        if (triggerToast) {
                          userWorker.userModelUpdater(
                              userWorker.usermodel.getUserId());
                          Fluttertoast.showToast(
                              msg: "Email adresiniz Güncellendi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 18.0);
                        }
                      });
                    },
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    height: 1,
                  ),
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.key),
                    label: Text('Şifreni güncelle'),
                    onPressed: () {
                      triggerToast = false;
                      showDialog(
                          context: context,
                          builder: (newcontext) {
                            return myUpdatePasswordDialog(userWorker);
                          }).whenComplete(() {
                        if (triggerToast) {
                          userWorker.userModelUpdater(
                              userWorker.usermodel.getUserId());
                          Fluttertoast.showToast(
                              msg: "Şifreniz Güncellendi",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 18.0);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  AlertDialog myChangeEmailDialog(UserService userWorker) {
    final BaseAuth auth = AuthService.of(context).auth;
    FirebaseUser user;
    TextEditingController controllerMevcut = TextEditingController();
    TextEditingController controllerYeni = TextEditingController();
    TextEditingController controllerMevcutPassword = TextEditingController();
    auth.getCurrentUser().then((data) {
      user = data;
    });

    return AlertDialog(
        content: StatefulBuilder(builder: (context, StateSetter setState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerMevcut,
                decoration:
                    InputDecoration(labelText: 'Mevcut Email adresiniz'),
                validator: (value) =>
                    value.isEmpty ? 'Geçerli email girilmeli' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                controller: controllerMevcutPassword,
                decoration: InputDecoration(labelText: 'Mevcut şifreniz'),
                validator: (value) =>
                    value.isEmpty ? 'Şifrenizi kontrol edin' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerYeni,
                decoration: InputDecoration(labelText: 'Yeni email adresiniz'),
                validator: (value) =>
                    value.isEmpty ? 'Geçerli email girilmeli' : null,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  //elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      minWidth: 50.0,
                      height: 30.0,
                      color: Color(0xFF179CDF),
                      child: Text(
                        "İptal",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  //elevation: 5.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        if (controllerMevcut.text ==
                                userWorker.usermodel.getUserEmail() &&
                            controllerYeni.text != null &&
                            await auth.checkPassword(controllerMevcut.text,
                                controllerMevcutPassword.text)) {
                          user.updateEmail(controllerYeni.text);
                          triggerToast = true;
                          userWorker.usermodel.setEmail(controllerYeni.text);
                          userWorker.updateInfo(
                              "Email", userWorker.usermodel.getUserEmail());
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Hata: Lütfen bilgileri kontrol ediniz!.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 18.0);
                          controllerYeni.clear();
                          controllerMevcut.clear();
                          controllerMevcutPassword.clear();
                        }
                      },
                      minWidth: 50.0,
                      height: 30.0,
                      color: Color(0xFF179CDF),
                      child: Text(
                        "Güncelle",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }));
  }

  AlertDialog myUpdatePasswordDialog(UserService userWorker) {
    final BaseAuth auth = AuthService.of(context).auth;
    FirebaseUser user;
    TextEditingController controllerYeni2Password = TextEditingController();
    TextEditingController controllerYeniPassword = TextEditingController();
    TextEditingController controllerMevcutPassword = TextEditingController();
    auth.getCurrentUser().then((data) {
      user = data;
    });

    return AlertDialog(
        content: StatefulBuilder(builder: (context, StateSetter setState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerMevcutPassword,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Mevcut şifreniz'),
                validator: (value) => value.isEmpty ? 'Boş olamaz' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerYeniPassword,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Yeni şifreniz'),
                validator: (value) => value.isEmpty ? 'Boş olamaz' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controllerYeni2Password,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Yeni şifreniz(Tekrar)'),
                validator: (value) => value.isEmpty ? 'Boş olamaz' : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Onayla"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(userWorker.usermodel.getUserEmail() +
                                  "\nBu email adresine bir şifre sıfırlama epostası gönderilecektir.\nOnaylıyormusunuz?")
                            ],
                          ),
                          actions: <Widget>[
                            Material(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  minWidth: 50.0,
                                  height: 30.0,
                                  color: Color(0xFF179CDF),
                                  child: Text(
                                    "İptal",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(30.0),
                              //elevation: 5.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  onPressed: () {
                                    auth.sendPasswordResetEmail(
                                        userWorker.usermodel.getUserEmail());
                                    Navigator.pop(context);
                                  },
                                  minWidth: 50.0,
                                  height: 30.0,
                                  color: Color(0xFF179CDF),
                                  child: Text(
                                    "Onayla",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "Şifremi unuttum.",
                  style: TextStyle(color: MyColors().blueThemeColor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      minWidth: 50.0,
                      height: 30.0,
                      color: Color(0xFF179CDF),
                      child: Text(
                        "İptal",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () async {
                        if (controllerYeniPassword.text ==
                                controllerYeni2Password.text &&
                            await auth.checkPassword(
                                userWorker.usermodel.getUserEmail(),
                                controllerYeniPassword.text)) {
                          user.updatePassword(controllerYeniPassword.text);
                          triggerToast = true;
                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Hata: Lütfen bilgileri kontrol ediniz!.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 18.0);
                        }
                        controllerMevcutPassword.clear();
                        controllerYeniPassword.clear();
                        controllerYeni2Password.clear();
                      },
                      minWidth: 50.0,
                      height: 30.0,
                      color: Color(0xFF179CDF),
                      child: Text(
                        "Kaydet",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      );
    }));
  }

  Widget updateMyPersonalInfoDialog(UserService userWorker) {
    File _image;

    String birthday = "${userWorker.usermodel.getUserBirthday()}";
    String displayedBirthday = "Şuanki doğum tarihiniz:" + birthday;
    String city;
    if (controllerAd == null) {
      controllerAd =
          TextEditingController(text: userWorker.usermodel.getUserName());
      controllerSoyad =
          TextEditingController(text: userWorker.usermodel.getUserSurname());
      controllerTelNo = TextEditingController(
          text: userWorker.usermodel.getUserTelno() == "null"
              ? ""
              : userWorker.usermodel.getUserTelno());
    }

    //REVIEW Alertdialog default ayarları sebebiyle yanlardan ayarlama yapılamıyor gerekirse custom birşeyler yap
    return AlertDialog(
      title: Text("Bilgileri Düzenle"),
      //ANCHOR dialoğun içinde ayrıyeten bir statefull oluşturdum
      content: StatefulBuilder(
        builder: (context, StateSetter setState) {
          Future<void> getImageFromCamera() async {
            _image = await ImagePicker.pickImage(source: ImageSource.camera)
                .whenComplete(() {
              setState(() {});
            });
          }

          Future<void> getImageFromGalery() async {
            _image = await ImagePicker.pickImage(source: ImageSource.gallery)
                .whenComplete(() {
              setState(() {});
            });
          }

          List<SearchItem<int>> sehirler = [];
          for (int i = 1; i <= 81; i++) {
            sehirler.add(SearchItem(i, Sehirler().sehirler[i - 1]));
          }

          return SingleChildScrollView(
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: ExtendedNetworkImageProvider(
                            userWorker.usermodel.getUserProfilePhotoUrl(),
                            cache: true),
                        fit: BoxFit.fill),
                    borderRadius: BorderRadius.circular(120.0),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(120.0),
                      child: _image == null
                          ? null //Text('Resim seçilmedi!.')
                          : Image.file(_image)),
                ),
                Row(
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
                        onTap: getImageFromGalery,
                        child: Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(120.0),
                            ),
                            child: Icon(FontAwesomeIcons.images)))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerAd,
                    decoration: InputDecoration(labelText: 'Adınız'),
                    validator: (value) =>
                        value.isEmpty ? 'Ad boş olamaz' : null,
                    onSaved: (value) => null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerSoyad,
                    decoration: InputDecoration(labelText: 'Soyadınız'),
                    validator: (value) =>
                        value.isEmpty ? 'Soyad boş olamaz' : null,
                    onSaved: (value) => null,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: controllerTelNo,
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Telefon Numarası'),
                    validator: (value) =>
                        value.isEmpty ? 'Telefon numarası boş olamaz' : null,
                    onSaved: (value) => null,
                  ),
                ),
                Text(
                  displayedBirthday,
                  style: TextStyle(fontSize: 15.0),
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
                          if (datePick != null) {
                            setState(() {
                              displayedBirthday = "Güncellenmiş doğum tarihiniz :" +
                                  "${datePick.day}/${datePick.month}/${datePick.year}";
                              birthday =
                                  "${datePick.day}/${datePick.month}/${datePick.year}";
                            });
                          }
                        }),
                  ],
                ),
                /*FindDropdown(
                  items: Sehirler().sehirler,
                  onChanged: (String item) {
                    city = item;
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
                        city = Sehirler().sehirler[item - 1];
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.circular(30.0),
                      //elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          minWidth: 50.0,
                          height: 30.0,
                          color: Color(0xFF179CDF),
                          child: Text(
                            "İptal",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(30.0),
                      //elevation: 5.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () async {
                            if (await userWorker.updateProfilePhoto(_image)) {
                              print("foto güncellendi");
                              triggerToast = true;
                            }
                            if (controllerAd.text !=
                                userWorker.usermodel.getUserName()) {
                              userWorker.updateInfo("Name", controllerAd.text);
                              triggerToast = true;
                            }
                            if (controllerSoyad.text !=
                                userWorker.usermodel.getUserSurname()) {
                              userWorker.updateInfo(
                                  "Surname", controllerSoyad.text);
                              triggerToast = true;
                            }
                            if (controllerTelNo.text !=
                                userWorker.usermodel.getUserTelno()) {
                              userWorker.updateInfo(
                                  "Telno", controllerTelNo.text);
                              triggerToast = true;
                            }
                            if (birthday !=
                                userWorker.usermodel.getUserBirthday()) {
                              userWorker.updateInfo("Birthday", birthday);
                              triggerToast = true;
                            }
                            if (city != null) {
                              userWorker.updateInfo("City", city);
                              triggerToast = true;
                            }
                            Navigator.pop(context);
                          },
                          minWidth: 50.0,
                          height: 30.0,
                          color: Color(0xFF179CDF),
                          child: Text(
                            "Kaydet",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
