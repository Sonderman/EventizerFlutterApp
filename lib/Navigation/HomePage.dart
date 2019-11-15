import 'package:eventizer/Auth_Sign_Register_v2/BaseAuth.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userEmail = "not received yet!";

  Future<void> getUserEmail() async {
    try {
      userEmail = await widget.auth.getUserEmail();
    } catch (e) {
      print('Kullanıcı maili alınırken hata : $e');
    } finally {
      setState(() {});
    }
  }

  @override
  initState() {
    super.initState();
    getUserEmail();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: "BottomNavDeneme",
      home: BottomNavWidget(),
    );
  }
}

//Bottom Navigation Widget kısmı
class BottomNavWidget extends StatefulWidget {
final BaseAuth auth;
final String userId;
final VoidCallback logoutCallback;
  BottomNavWidget({this.auth, this.userId, this.logoutCallback});
  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

//State kısmı
class _BottomNavWidgetState extends State<BottomNavWidget> {
  int _selectedIndex = 0;
  BaseAuth auth;
  String userId;
  VoidCallback logoutCallback;
  @override
  initState() {
    super.initState();
    auth=widget.auth;
    userId=widget.userId;
    logoutCallback=widget.logoutCallback;
  }
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

// Sayfaların bulunduğu liste
  List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
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
      /*appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),*/
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: _onItemTapped,
      ),
    );
  }
}
