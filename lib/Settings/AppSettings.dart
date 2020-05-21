import 'package:flutter/material.dart';

class AppSettings with ChangeNotifier {
  int _bottomNavIndex = 1;

  List<Widget> _pageStack = [];

  void refresh() {
    notifyListeners();
  }

  //ANCHOR Getters Here
  int getBottomNavIndex() => _bottomNavIndex;
  List<Widget> getPageStack() => _pageStack;

  //ANCHOR Setters Here
  void setBottomNavIndex(int index) {
    _bottomNavIndex = index;
    refresh();
  }

  void flushStack() {
    _pageStack.clear();
  }

  void pushPage(Widget page) {
    _pageStack.add(page);
    refresh();
  }

  void popPage() {
    _pageStack.removeLast();
    refresh();
  }
}
