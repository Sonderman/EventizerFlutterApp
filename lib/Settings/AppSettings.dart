import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  int _bottomNavIndex = 2;

  int getBottomNavIndex() => _bottomNavIndex;

  void setBottomNavIndex(int newIndex) {
    _bottomNavIndex = newIndex;
    //print(_bottomNavIndex);
    notifyListeners();
  }
}
