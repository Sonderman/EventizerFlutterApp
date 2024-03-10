import 'dart:io';
import 'dart:math';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/ImageEditor.dart';
import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'Components/CustomScroll.dart';

class SignUpPage extends StatefulWidget {
  final PageController pageController;

  const SignUpPage(this.pageController, {super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController password2Controller = TextEditingController();
  Uint8List? _image;
  bool loading = false;
  String? _name, _surname, _phoneNumber, _birthday;
  bool? _gender;
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
  Future<Uint8List?> _getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ImageEditorPage(
                    image: File(image.path),
                    forCreateEvent: false,
                  ))).then((value) => value);
    } else {
      return null;
    }
  }

// ANCHOR galeriden foto almaya yarar
  Future<Uint8List?> _getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => ImageEditorPage(
                    image: File(image.path),
                    forCreateEvent: false,
                  ))).then((value) => value);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading
        ? const Loading()
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ScrollConfiguration(
                behavior: NoScrollEffectBehavior(),
                child: SingleChildScrollView(
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
                      child: const Text(
                        'Galeri',
                      ),
                      onTap: () {
                        _getImageFromGallery().then((value) {
                          setState(() {
                            _image = value;
                            Navigator.pop(context);
                          });
                        });
                      }),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: const Text(
                        'Kamera',
                      ),
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

  String generateNickName(String name) {
    return name + (1 + Random().nextInt(9998)).toString();
  }

  void signUp() async {
    //ANCHOR Veritabanına kaydetmek için
    List<String?>? datalist = [
      _name,
      _surname,
      mailController.text,
      _phoneNumber,
      _gender! ? "Man" : "Woman",
      _birthday,
      generateNickName(_name!)
    ];
    print(datalist);
    try {
      await Provider.of<UserService>(context, listen: false)
          .registerUser(
              mailController.text, passwordController.text, datalist, _image!)
          .then((userID) {
        if (userID != null) {
          print("Upload işlemi bitti");

          Fluttertoast.showToast(
              msg:
                  "Hesabınız başarıyla oluşturuldu. Lütfen mailinizi doğrulayınız.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 18.0);
          widget.pageController.previousPage(
              duration: const Duration(seconds: 1),
              curve: Curves.easeInOutCubic);
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
      child: SizedBox(
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
                  child: Image.memory(
                    _image!,
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
        SizedBox(
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
        SizedBox(
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
            suffixIcon: TextButton(
              child:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              // splashColor: Colors.transparent,
              //highlightColor: Colors.transparent,
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
            suffixIcon: TextButton(
              child:
                  Icon(showPassword ? Icons.visibility : Icons.visibility_off),
              //splashColor: Colors.transparent,
              //highlightColor: Colors.transparent,
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
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
    return InkWell(
      onTap: () async {
        final datePick = await showDatePicker(
            context: context,
            initialDate: DateTime(DateTime.now().year - 18),
            firstDate: DateTime(DateTime.now().year - 70),
            lastDate: DateTime(DateTime.now().year - 18));
        if (datePick != null) {
          setState(() {
            _birthday = "${datePick.day}/${datePick.month}/${datePick.year}";
          });
        }
      },
      child: Container(
        width: widthSize(70),
        height: heightSize(8),
        decoration: BoxDecoration(
          color: MyColors().yellowContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Center(
          child: Text(
            _birthday != null ? _birthday! : "Doğum Tarihiniz",
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
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender!
                      ? Colors.black
                      : menColor()
                  : menColor(),
              borderRadius: const BorderRadius.all(
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
            decoration: BoxDecoration(
              color: _gender != null
                  ? _gender!
                      ? womenColor()
                      : Colors.black
                  : womenColor(),
              borderRadius: const BorderRadius.all(
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
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          child: TextButton(
            style: ButtonStyle(
                iconColor:
                    MaterialStateProperty.all(MyColors().purpleContainer)),

            //highlightColor: MyColors().purpleContainerSplash,
            //splashColor: MyColors().purpleContainerSplash,
            onPressed: () {
              widget.pageController.previousPage(
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeInOutCubic);
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
                passwordController.text == password2Controller.text &&
                _gender != null &&
                _birthday != null) {
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
            width: widthSize(42),
            height: heightSize(8),
            decoration: BoxDecoration(
              color: MyColors().purpleContainer,
              borderRadius: const BorderRadius.all(
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

  menColor() {
    return MyColors().blueContainer;
  }

  womenColor() {
    return Colors.pinkAccent;
  }
}
