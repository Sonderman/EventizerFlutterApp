import 'package:eventizer/Services/NavigationProvider.dart';
import 'package:eventizer/Tools/BottomNavigation.dart';
import 'package:eventizer/Tools/Dialogs.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/Tools/PageComponents.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    height: responsive.heightSize(30),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.info_outline,
                          size: 40,
                        ),
                      ),
                      Text("Hakkımızda"),
                    ],
                  ),
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
