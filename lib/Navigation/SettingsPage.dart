import 'dart:io';
import 'dart:typed_data';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/ImageEditor.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/assets/Sehirler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UserService userService;
  User userModel;
  final PageController pageController = PageController();
  TextEditingController mailController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Uint8List _image;
  bool loading = false;
  String _name, _surname, _phoneNumber, _country, _city;

  get city => _city;

  set city(value) {
    _city = value;
  }

  bool showPassword = true;

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context);
    userModel = userService.userModel;
    mailController.text = userModel.getUserEmail();
    detailController.text = userModel.getUserAbout();
    super.didChangeDependencies();
  }

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
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
                    /*
                    SizedBox(
                      height: heightSize(1),
                    ),
                    emailField(),
                     */
                    SizedBox(
                      height: heightSize(1),
                    ),
                    detailField(),
                    SizedBox(
                      height: heightSize(2),
                    ),
                    telephoneNumber(),
                    SizedBox(
                      height: heightSize(2),
                    ),
                    countryAndCity(),
                    SizedBox(
                      height: heightSize(2),
                    ),
                    saveChangesButton(),
                    SizedBox(
                      height: heightSize(2),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget detailField() {
    return TextFormField(
      controller: detailController,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.multiline,
      enableInteractiveSelection: true,
      minLines: 2,
      maxLines: 10,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Hakkımda",
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

// ANCHOR kameradan foto almaya yarar
  Future<Uint8List> _getImageFromCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null)
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ImageEditorPage(
                    image: image,
                    forCreateEvent: false,
                  ))).then((value) => value);
    else
      return null;
  }

// ANCHOR galeriden foto almaya yarar
  Future<Uint8List> _getImageFromGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (image != null)
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ImageEditorPage(
                    image: image,
                    forCreateEvent: false,
                  ))).then((value) => value);
    else
      return null;
  }

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
                        _getImageFromGallery().then((value) {
                          setState(() {
                            _image = value;
                            Navigator.pop(context);
                          });
                        });
                      }),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: Text('Kamera'),
                      onTap: () {
                        _getImageFromCamera().then((value) {
                          setState(() {
                            _image = value;
                            Navigator.pop(context);
                          });
                        });
                      }),
                ],
              ),
            ),
          );
        });
  }

  void saveChanges() async {
    setState(() {
      loading = true;
    });
    userService.userModelUpdater(userModel).then((value) async {
      if (value) {
        if (await Provider.of<UserService>(context, listen: false)
            .userModelSync()) {
          NavigationManager(context).popPage();
        }

        Fluttertoast.showToast(
            msg: "Bilgileriniz Güncellenmiştir",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 18.0);
      } else {
        setState(() {
          loading = false;
          Fluttertoast.showToast(
              msg: "İnternet bağlantınızı kontrol ediniz!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 18.0);
          NavigationManager(context).popPage();
        });
      }
    });
  }

  Widget addPhoto() {
    return GestureDetector(
      onTap: () {
        _showChoiceDialog(context);
      },
      child: Center(
        child: Container(
          height: widthSize(50),
          width: widthSize(50),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: _image == null
                      ? NetworkImage(userModel.getUserProfilePhotoUrl())
                      : MemoryImage(_image))),
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
            initialValue: userModel.getUserName(),
            onChanged: (ad) => _name = ad,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              hintText: "Ad*",
              border: InputBorder.none,
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
            initialValue: userModel.getUserSurname(),
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

  Widget emailField() {
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
        /*
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
    */
      ],
    );
  }

  Widget telephoneNumber() {
    return TextFormField(
      initialValue: userModel.getUserTelNo() == 0
          ? null
          : userModel.getUserTelNo().toString(),
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

  Widget countryAndCity() {
    List<DropdownMenuItem<String>> sehirler = [];
    for (int i = 0; i < 81; i++) {
      sehirler.add(DropdownMenuItem(
        value: Sehirler().sehirler[i],
        child: Text(Sehirler().sehirler[i]),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: heightSize(10),
            width: widthSize(90),
            child: SearchableDropdown.single(
              label: "Sehir Seçin",
              items: sehirler,
              hint: userModel.getUserCity() ?? "Şehir Seçin",
              searchHint: "Şehir Seçin",
              onChanged: (value) {
                if (value != 0 && value != null) {
                  setState(() {
                    _city = value;
                    print("CITY:" + _city);
                  });
                }
              },
              displayClearIcon: false,
              isExpanded: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget saveChangesButton() {
    return InkWell(
      onTap: () async {
        //ANCHOR veri kontrolleri burda
        bool isChanged = false;
        if (_name != null) {
          isChanged = true;
          userModel.setUserName(_name);
        }
        if (_surname != null) {
          isChanged = true;
          userModel.setUserSurname(_surname);
        }
        /*
        if (mailController.text != null) {
          isChanged = true;
          userModel.setUserEmail(mailController.text);
        }*/
        if (detailController.text != null) {
          isChanged = true;
          userModel.setUserAbout(detailController.text);
        }
        if (_country != null) {
          isChanged = true;
          userModel.setUserCountry(_country);
        }

        if (_city != null) {
          isChanged = true;
          userModel.setUserCity(_city);
        }
        if (_phoneNumber != null) {
          isChanged = true;
          userModel.setUserTelNo(int.parse(_phoneNumber));
        }
        if (_image != null) {
          setState(() {
            loading = true;
          });
          if (!await userService.updateProfilePhoto(_image)) {
            Fluttertoast.showToast(
                msg:
                    " Resim Güncellenemedi,İnternet bağlantınızı kontrol ediniz!",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 18.0);
          }
        }
        if (isChanged) {
          saveChanges();
        } else {
          Fluttertoast.showToast(
              msg: "Güncellemek için değişiklik yapmalısınız",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 18.0);
        }
      },
      child: Container(
        width: widthSize(75),
        height: heightSize(8),
        decoration: new BoxDecoration(
          color: MyColors().purpleContainer,
          borderRadius: new BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            "Güncelle",
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
}
