import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  String? userId;
  String? _email;

  @override
  Widget build(BuildContext context) {
    // ANCHOR MediaQuery ile uygulamanin acildigi telefonun boyutunu aldik
    var screenSize = MediaQuery.of(context).size;
    // ANCHOR telefonun height ve width ini degiskenlere atadik
    final height = screenSize.height;
    final width = screenSize.width;
    return Scaffold(
      backgroundColor: Colors.white,
      // ANCHOR Column Widgedtimiz iki ayri Widget barindiriyor
      // ANCHOR 1. Ust kisim Background imagelerin bulundugu kisim
      // ANCHOR 2. alt kisim formlarimizin ve textlerimizin bulundugu kisim
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 7,
            child: Container(
              height: height * 0.3 + 40,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: height * 0.3 + 40,
                    width: width,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    height: height * 0.3 + 40,
                    width: width + 20,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background-2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height * 0.1 + 40,
                    height: height * 0.3 + 40,
                    width: width + 20,
                    child: Text(
                      "Eventizer",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'IndieFlower',
                        fontSize: 30,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 13,
            child: Form(
              key: formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Şifremi Sıfırla",
                      style: TextStyle(
                        color: Color.fromRGBO(49, 39, 79, 1),
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(196, 135, 198, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            )),
                            child: TextFormField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email Adresi",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              validator: (value) => value!.isEmpty
                                  ? 'Email Adress Boş Olamaz'
                                  : 'Şifrenizi sıfırlamak için Email Adresinizi kontrol ediniz',
                              onSaved: (value) => _email = value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      onPressed: () {},
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 70),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color.fromRGBO(49, 39, 79, 1),
                        ),
                        child: Center(
                          child: Text(
                            "Şifremi Yenile",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
