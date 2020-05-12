import 'package:eventizer/Navigation/Old/OldChatsPage.dart';
import 'package:eventizer/Navigation/CreateEventPage.dart';
import 'package:eventizer/Navigation/EditProfilePage.dart';
import 'package:eventizer/Navigation/EventPage.dart';
import 'package:eventizer/Navigation/ExploreEventPage.dart';
import 'package:eventizer/Navigation/Old/OldLoginPage.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Navigation/SignupPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'ChatPage.dart';
import 'LoginPage.dart';

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
  int _selectedIndex = 3;

  //static const TextStyle optionStyle =
  //   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserService userWorker = Provider.of<UserService>(context);

    List<Widget> _widgetOptions = <Widget>[
      ChatPage(),
      CreateEventPage(),
      ProfilePage(userID: userWorker.usermodel.getUserId(), isFromEvent: false),
      ExploreEventPage(),
      //SettingsPage()
    ];

    return WillPopScope(
      onWillPop: askForQuit,
      child: Scaffold(
          //backgroundColor: Colors.yellow,
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
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

          bottomNavigationBar: FancyBottomNavigation(
            initialSelection: 3,
            inactiveIconColor: MyColors().purpleContainer,
            circleColor: MyColors().purpleContainer,
            tabs: [
              TabData(
                iconData: Icons.chat,
                title: "Chat",
                onclick: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatPage())).then((value) {
                    //ANCHOR Yeni etkinlik oluşturulduğunda sayfayı güncelliyor
                    if (value == "success") {
                      setState(() {});
                    }
                  });
                },
              ),
              TabData(
                iconData: Icons.add,
                title: "Oluştur",
                onclick: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateEventPage())).then((value) {
                    //ANCHOR Yeni etkinlik oluşturulduğunda sayfayı güncelliyor
                    if (value == "success") {
                      setState(() {});
                    }
                  });
                },
              ),
              TabData(
                iconData: Icons.assignment_ind,
                title: "Profil",
                onclick: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProfilePage(userID: userWorker.usermodel.getUserId(), isFromEvent: false))).then((value) {
                    //ANCHOR Yeni etkinlik oluşturulduğunda sayfayı güncelliyor
                    if (value == "success") {
                      setState(() {});
                    }
                  });
                },
              ),
              TabData(
                iconData: Icons.search,
                title: "Keşfet",
                onclick: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ExploreEventPage())).then((value) {
                    //ANCHOR Yeni etkinlik oluşturulduğunda sayfayı güncelliyor
                    if (value == "success") {
                      setState(() {});
                    }
                  });
                },
              ),
            ],
            onTabChangedListener: (position) {
              setState(() {
                position = _selectedIndex;
              });
            },
          )
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

          ),
    );
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
