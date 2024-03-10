import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';

class NavigationProvider with ChangeNotifier {
  int _bottomNavIndex = locator<AppSettings>().defaultNavIndex;
  final PageController _createEventPageController = PageController(
    initialPage: 0,
  );

  final List<Widget> _pageStack = [];

  void refresh() {
    notifyListeners();
  }

  //ANCHOR Getters Here
  int getBottomNavIndex() => _bottomNavIndex;
  List<Widget> getPageStack() => _pageStack;
  PageController getCreateEventPageController() => _createEventPageController;

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
  }

  void popPage() {
    _pageStack.removeLast();
    refresh();
  }
}
