import 'package:eventizer/Services/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ProfilePage.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userEmail = "not received yet!";

  Future<void> getUserEmail() async {
    try {
      var auth = AuthProvider.of(context).auth;
      userEmail = await auth.getUserEmail();
    } catch (e) {
      print('Kullanıcı maili alınırken hata : $e');
    } finally {
      setState(() {});
    }
  }

 @override
  void didChangeDependencies() {
    getUserEmail();
    super.didChangeDependencies();
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

  BottomNavWidget();
  @override
  _BottomNavWidgetState createState() => _BottomNavWidgetState();
}

//State kısmı
class _BottomNavWidgetState extends State<BottomNavWidget> {
  int _selectedIndex = 1;

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
