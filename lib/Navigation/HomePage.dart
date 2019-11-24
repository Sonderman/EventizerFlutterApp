import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Providers/AuthProvider.dart';
import 'package:eventizer/Services/UserWorker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userEmail = "not received yet!";
  String userUid;

  Future<void> setThings() async {
    try {
      var auth = AuthProvider.of(context).auth;

      userUid = await auth.getUserUid();
    } catch (e) {
      print('Kullanıcı maili alınırken hata : $e');
    }
    
  }

  @override
  void didChangeDependencies() {
    setThings();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BottomNavDeneme",
      home: BottomNavWidget(),
    );
  }
}

//Bottom Navigation Widget kısmı
class BottomNavWidget extends StatefulWidget {

  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

//State kısmı
class _BottomNavWidgetState extends State<BottomNavWidget> {
  int _selectedIndex = 2;
  

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

// Sayfaların bulunduğu liste
  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Mesajlaşma Sayfası',
      style: optionStyle,
    ),
    Text(
      'Keşfet Sayfası',
      style: optionStyle,
    ),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8.0,
        backgroundColor: Color(0XFF001970),
        iconSize: 30.0,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items:<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.comments, size: 26.0),
            title: Text('Mesajlar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            title: Text('Keşfet'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text('Profil'),
          ),
        ],
      ),
    );
  }
}
