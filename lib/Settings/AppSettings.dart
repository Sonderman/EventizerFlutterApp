import 'package:flutter/material.dart';

enum AppState { running, waiting }

class AppSettings with ChangeNotifier {
  String appName = "EventizerApp";

  // String _server = "Release";
  String _server = "Development";
  //String _server = "OpenTest";
  AppState state = AppState.running;
  String getServer() => _server;

  int _bottomNavIndex = 2;
  PageController _createEventPageController = PageController(
    initialPage: 0,
  );

  List<Widget> _pageStack = [];

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
