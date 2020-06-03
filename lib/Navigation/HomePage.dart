import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/Tools/BottomNavigation.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavWidget(),
    );
  }
}

class BottomNavWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> askForQuit() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Uygulamadan Çıkmak istiyormusunuz?"),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Hayır")),
                FlatButton(
                    onPressed: () {
                      SystemNavigator.pop();
                      //Navigator.pop(context);
                    },
                    child: Text("Evet"))
              ],
            ));

    //ANCHOR burada stack de widget varmı kontrol eder, eğer widget varsa pop eder
    Future<bool> onBackButtonPressed() async {
      if (NavigationManager(context).onBackButtonPressed()) {
        return Future.value(false);
      } else {
        return await askForQuit();
      }
    }

    //ANCHOR willpopscope geri tusunu kontrol eder
    return WillPopScope(
        onWillPop: onBackButtonPressed,
        child: Scaffold(
            body: Consumer<AppSettings>(
              builder: (con, settings, w) => getNavigatedPage(context),
            ),
            bottomNavigationBar: bottomNavigationBar(context)));
  }
}
