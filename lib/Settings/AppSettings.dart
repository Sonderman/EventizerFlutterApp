import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  int _bottomNavIndex = 2;

  Widget _currentPageWidget;

  Widget getCurrentPage() => _currentPageWidget;

  void setCurrentPage(Widget page) {
    _currentPageWidget = page;
    notifyListeners();
  }

  int getBottomNavIndex() => _bottomNavIndex;

  void setBottomNavIndex(int newIndex) {
    _bottomNavIndex = newIndex;
    _currentPageWidget = null; //Only clever boys can do this:D
    notifyListeners();
  }
}
