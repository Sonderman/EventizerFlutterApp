import 'package:eventizer/Services/NavigationProvider.dart';
import 'package:eventizer/Tools/BottomNavigation.dart';
import 'package:eventizer/Tools/Dialogs.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var responsive = PageComponents(context);
    //ANCHOR willpopscope geri tusunu kontrol eder
    return WillPopScope(
        onWillPop: onBackButtonPressed,
        child: Scaffold(
            drawerEnableOpenDragGesture: true,
            drawer: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: responsive.heightSize(20),
                  ),
                  Container(
                      child: Center(
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Bu uygulama\n",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.widthSize(4))),
                          TextSpan(
                              text: "Ali Haydar AYAR\n",
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: responsive.widthSize(4)),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      'https://www.linkedin.com/in/alihaydar-ayar-b45a4315b/';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                }),
                          TextSpan(
                              text: " Ve\n",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.widthSize(4))),
                          TextSpan(
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  fontSize: responsive.widthSize(4)),
                              text: "Murat ALTINTAŞ\n",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  const url =
                                      'https://www.linkedin.com/in/murat-alt%C4%B1nta%C5%9F-bb58b4145/';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  }
                                }),
                          TextSpan(
                              text: "tarafından geliştirilmiştir.\n\n",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.widthSize(4))),/*
                          TextSpan(
                              text:
                                  "Her türlü görüş ve önerileriniz için eventizer.official@gmail.com adresine mail gönderebilirsiniz. Uygulamayı beğenip paylaşmanızı rica ederiz.\n",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: responsive.widthSize(4))),*/
                        ])),
                  )),
                  MaterialButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.play_arrow),
                          Text("Play Store"),
                        ],
                      ),
                      color: Colors.green,
                      onPressed: () {
                        StoreRedirect.redirect();
                      }),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      feedbackDialog(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.feedback,
                            size: 40,
                          ),
                        ),
                        Text("Sorun Bildir"),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: responsive.heightSize(10),
                  ),
                ],
              ),
            ),
            body: Consumer<NavigationProvider>(
              builder: (con, nav, w) => getNavigatedPage(context),
            ),
            bottomNavigationBar: bottomNavigationBar(context)));
  }

  //ANCHOR burada stack de widget varmı kontrol eder, eğer widget varsa pop eder
  Future<bool> onBackButtonPressed() async {
    if (NavigationManager(context).onBackButtonPressed()) {
      return Future.value(false);
    } else {
      return await askForQuit(context);
    }
  }
}
