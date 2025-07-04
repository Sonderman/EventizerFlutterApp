import 'package:eventizer/Navigation/HomePage.dart';
import 'package:eventizer/Navigation/SignUpPage.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userId;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorText;
  bool _loading = false;
  bool visiblePassword = true;
  bool showLogin = false;
  String sendPasswordMailText = "Giriş Yap";
  UserService userService;
  PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget welcomeText() {
    if (visiblePassword == false) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Şifre Sıfırlama",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(4),
              color: MyColors().loginGreyColor,
            ),
          ),
          Text(
            "Mail Adresini Gir",
            style: TextStyle(
              height: heightSize(0.2),
              fontFamily: "ZonaLight",
              fontSize: heightSize(3.3),
              color: MyColors().greyTextColor,
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tekrar Hoşgeldin",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: heightSize(4),
              color: MyColors().loginGreyColor,
            ),
          ),
          Text(
            "Giriş yap ve devam et",
            style: TextStyle(
              height: heightSize(0.2),
              fontFamily: "ZonaLight",
              fontSize: heightSize(3.3),
              color: MyColors().greyTextColor,
            ),
          ),
        ],
      );
    }
  }

  Widget emailAndPasswordFields() {
    return Column(
      children: <Widget>[
        TextFormField(
          //onSaved: (value) => email = value,
          controller: email,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email",
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
        Visibility(
          visible: showLogin,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: heightSize(2),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    rememberPass();
                  },
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      fontFamily: "ZonaLight",
                      fontSize: heightSize(2),
                      color: MyColors().loginGreyColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: heightSize(5),
        ),
        passwordField(password),
      ],
    );
  }

  Widget passwordField(password) {
    bool showPassword = true;
    print("building custom stateful textfield password");
    return StatefulBuilder(
      builder: (context, state) {
        print("building internal state");
        return Visibility(
          visible: visiblePassword,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      //onSaved: (value) => password = value,
                      controller: password,
                      obscureText: showPassword,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        errorText: errorText,
                        errorStyle: TextStyle(
                          fontSize: heightSize(2),
                          fontFamily: "Zona",
                          color: Colors.red,
                        ),
                        border: InputBorder.none,
                        hintText: "Şifre",
                        hintStyle: TextStyle(
                          fontFamily: "Zona",
                          color: MyColors().loginGreyColor,
                        ),
                        alignLabelWithHint: true,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors().loginGreyColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: MyColors().loginGreyColor),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: heightSize(2.5),
                        fontFamily: "ZonaLight",
                        color: MyColors().loginGreyColor,
                      ),
                    ),
                  ),
                  Center(
                    child: SizedBox(
                      width: widthSize(12),
                      height: heightSize(6),
                      child: FlatButton(
                        child: Icon(showPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onPressed: () {
                          state(() {
                            showPassword = !showPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ],
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
          ),
        );
      },
    );
  }

  Widget signInButton() {
    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FlatButton(
            color: MyColors().purpleContainer,
            highlightColor: MyColors().purpleContainerSplash,
            splashColor: MyColors().purpleContainerSplash,
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
            },
            child: Container(
              height: heightSize(8),
              width: widthSize(35),
              alignment: Alignment.center,
              child: Text(
                "Hesabım Yok",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.5),
                  color: MyColors().whiteTextColor,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: FlatButton(
            color: MyColors().purpleContainer,
            highlightColor: MyColors().purpleContainerSplash,
            splashColor: MyColors().purpleContainerSplash,
            onPressed: () {
              if (visiblePassword == true) {
                setState(() {
                  _loading = true;
                });
                loginButton(context);
              } else {
                passwordReset(context);
              }
            },
            child: Container(
              height: heightSize(8),
              width: widthSize(35),
              alignment: Alignment.center,
              child: Text(
                sendPasswordMailText,
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: heightSize(2.5),
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
    return Scaffold(
      body: Stack(
          children: <Widget>[
                PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: <Widget>[
                    //ANCHOR Login sayfası
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: heightSize(10),
                          ),
                          welcomeText(),
                          SizedBox(
                            height: heightSize(5),
                          ),
                          emailAndPasswordFields(),
                          Spacer(),
                          signInButton(),
                          SizedBox(
                            height: heightSize(1),
                          ),
                          SizedBox(
                            height: heightSize(5),
                          ),
                        ],
                      ),
                    ),
                    //ANCHOR SignUp sayfası
                    SignUpPage(_pageController)
                  ],
                )
              ] +
              (_loading
                  ? [
                      PageComponents(context)
                          .loadingOverlay(backgroundColor: Colors.white)
                    ]
                  : [])),
    );
  }

  Future<void> loginButton(BuildContext context) async {
    var auth = locator<AuthService>();
    userId = await auth.signIn(email.text, password.text);
    if (userId == null) {
      setState(() => _loading = false);
      Fluttertoast.showToast(
          msg: "Şifre veya Eposta yanlış!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0);
    } else {
      userService.userInitializer(userId).whenComplete(() async {
        await userService
            .updateSingleInfo("LastLoggedIn", "timeStamp")
            .whenComplete(() {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => HomePage()));
        });
      });
    }
  }

  void forgetPassword() {
    setState(() {
      visiblePassword = !visiblePassword;
      sendPasswordMailText = "Mail Gönder";
      showLogin = true;
    });
  }

  Future<void> passwordReset(BuildContext context) async {
    var auth = locator<AuthService>().getUserUid();
    //ANCHOR release yaparken açılacak
    //auth.sendPasswordResetEmail(email.text);
    debugPrint("şifre sıfırlama maili gönderildi");
  }

  void rememberPass() {
    setState(() {
      if (visiblePassword == false) {
        sendPasswordMailText = "Giriş Yap";
        visiblePassword = true;
        showLogin = false;
      }
    });
  }
}
