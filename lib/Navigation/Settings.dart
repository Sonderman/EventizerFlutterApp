import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Color myBlueColor = Color(0XFF001970);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myBlueColor,
      appBar: AppBar(
        title: Text("Ayarlar"),
        backgroundColor: myBlueColor,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.user),
                    label: Text('Kişisel bilgileri düzenle'),
                    onPressed: () {},
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    height: 1,
                  ),
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.user),
                    label: Text('Kişisel bilgileri düzenle'),
                    onPressed: () {},
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    height: 1,
                  ),
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.user),
                    label: Text('Kişisel bilgileri düzenle'),
                    onPressed: () {},
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    height: 1,
                  ),
                  FlatButton.icon(
                    icon: Icon(LineAwesomeIcons.user),
                    label: Text('Kişisel bilgileri düzenle'),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
