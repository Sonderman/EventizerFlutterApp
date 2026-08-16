import 'package:flutter/material.dart';

class MyColors {
  static Color globalTextColor = Colors.white;
  static Color iconColor = Colors.white;
  static Color innerContainerColor = Colors.white.withValues(alpha: 0.08);
  //Old Colors
  static Color blueThemeColor = const Color(0xFF173E67);
  static Color whiteThemeColor = Colors.white;
  static Color yellowContainer = Colors.white.withValues(alpha: 0.18);
  static Color blueContainer = const Color(0x4D3FA9F5);
  static Color orangeContainer = const Color(0x4DFFB86B);
  static Color loginGreyColor = Colors.white.withValues(alpha: 0.88);
  static Color lightGreen = const Color(0x4036D6C3);
  static Color darkblueText = Colors.white;
  static Color blackOpacityContainer = Colors.white.withValues(alpha: 0.14);
  static Color lightBlueContainer = const Color(0x4D66CCFF);
  static Color purpleContainer = const Color(0x665A8DEE);
  static Color purpleContainerSplash = const Color(0x995A8DEE);
  static Color purpleTextColor = Colors.white;
  static Color blueTextColor = const Color(0xFF9CD6FF);
  static Color greyTextColor = Colors.white70;
  static Color indiagoLoadingSplash = const Color(0xFF31506F);
}

class MyTextStyles {
  static TextStyle loginPageTextStyle({double fontsize = 15}) => TextStyle(
    fontFamily: "ZonaLight",
    fontSize: fontsize,
    color: Colors.white,
  );
}
