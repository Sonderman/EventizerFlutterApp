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
            //backgroundColor: Colors.yellow,
            body: Center(
              child: Consumer<AppSettings>(
                builder: (con, settings, w) => getNavigatedPage(context),
              ),
            ),

            /*
          floatingActionButton: FloatingActionButton(
            backgroundColor: MyColors().blueThemeColor,
            foregroundColor: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateEventPage())).then((value) {
                //ANCHOR Yeni etkinlik oluşturulduğunda sayfayı güncelliyor
                if (value == "success") {
                  setState(() {});
                }
              });
            },
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30), side: BorderSide(color: Colors.white, width: 5)),
            child: Icon(Icons.add),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
           */

            bottomNavigationBar: bottomNavigationBar(context)));

/*
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 8.0,
            backgroundColor: MyColors().lightBlueContainer,
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blueGrey,
            unselectedItemColor: Colors.white,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.inbox),
                title: Text('Gelen Kutusu'),
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.search),
                title: Text('Keşfet'),
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.user),
                title: Text('Profil'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text('Ayarlar'),
              ),
            ],
          ),

 */
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
