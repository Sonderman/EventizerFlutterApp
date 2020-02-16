import 'package:eventizer/Navigation/ChatsPage.dart';
import 'package:eventizer/Navigation/CreateEvent.dart';
import 'package:eventizer/Navigation/ExplorePage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:provider/provider.dart';
import 'ProfilePage.dart';

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
  int _selectedIndex = 0;

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
      ChatsPage(),
      ExplorePage(),
      ProfilePage(userWorker.getUserId(), false),
      SettingsPage()
    ];

    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 1.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 8.0,
          backgroundColor: MyColors().blueThemeColor,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.yellowAccent,
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
      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: MyColors().blueThemeColor,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CreateEvent()));
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.white, width: 5)),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
