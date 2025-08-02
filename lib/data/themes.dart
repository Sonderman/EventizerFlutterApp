import 'package:flutter/material.dart';

class MyColors {
  static Color globalTextColor = Colors.white;
  static Color iconColor = Colors.white;
  static Color innerContainerColor = Colors.white.withOpacity(0.1);
  //Old Colors
  static Color blueThemeColor = const Color(0XFF001970);
  static Color whiteThemeColor = Colors.white;
  static Color yellowContainer = Colors.orange.shade200;
  static Color blueContainer = Colors.blue;
  static Color orangeContainer = Colors.orange;
  static Color loginGreyColor = Colors.black.withOpacity(0.7);
  static Color lightGreen = Colors.lightGreen;
  static Color darkblueText = Colors.blue.shade900;
  static Color blackOpacityContainer = Colors.black.withOpacity(0.15);
  static Color lightBlueContainer = Colors.lightBlueAccent;
  static Color purpleContainer = Colors.deepPurple;
  static Color purpleContainerSplash = Colors.deepPurpleAccent;
  static Color purpleTextColor = Colors.deepPurple;
  static Color blueTextColor = Colors.blueAccent;
  static Color greyTextColor = Colors.grey;
  static Color indiagoLoadingSplash = Colors.indigo.shade700;
}

class MyTextStyles {
  static TextStyle loginPageTextStyle({double fontsize = 15}) =>
      TextStyle(fontFamily: "ZonaLight", fontSize: fontsize, color: Colors.white);
}
