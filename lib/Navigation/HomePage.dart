import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/Tools/BottomNavigation.dart';
import 'package:flutter/material.dart';
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

//Bottom Navigation Widget kısmı
class BottomNavWidget extends StatefulWidget {
  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends State<BottomNavWidget> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: askForQuit,
        child: Scaffold(
            body: Center(
              child: Consumer<AppSettings>(
                builder: (con, settings, w) => getNavigatedPage(context),
              ),
            ),
            bottomNavigationBar: bottomNavigationBar(context)));
  }

  Future<bool> askForQuit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Uygulamadan Çıkmak istiyormusunuz?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("Hayır")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text("Evet"))
            ],
          ));
}
