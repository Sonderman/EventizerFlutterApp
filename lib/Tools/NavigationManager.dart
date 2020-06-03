import 'package:eventizer/Settings/AppSettings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationManager {
  AppSettings settings;

  /*
  NOTE stackPage e sayfa eklemek için istediğin yerde bunu çağır :: NavigationManager(context).pushPage(Widget)
  NOTE geri gelmek için bunu çağır :: NavigationManager(context).popPage();
  */

  NavigationManager(BuildContext context) {
    settings = Provider.of<AppSettings>(context, listen: false);
  }

  bool onBackButtonPressed() {
    if (settings.getBottomNavIndex() == 1 &&
        settings.getCreateEventPageController().page == 1) {
      settings.getCreateEventPageController().previousPage(
          duration: Duration(seconds: 1), curve: Curves.easeInOutCubic);
      return true;
    } else if (isEmpty()) {
      return false;
    } else {
      popPage();
      return true;
    }
  }

  PageController getCreateEventPageController() =>
      settings.getCreateEventPageController();

  bool isEmpty() {
    return settings.getPageStack().isEmpty;
  }

  Widget getLastPage() {
    if (isEmpty()) {
      return null;
    } else
      return settings.getPageStack().last;
  }

  void popPage() {
    if (!isEmpty()) {
      settings.popPage();
    }
  }

  void pushPage(Widget page) {
    settings.pushPage(page);
  }

  int getBottomNavIndex() {
    return settings.getBottomNavIndex();
  }

  void setBottomNavIndex(int newIndex) {
    if (settings.getBottomNavIndex() != newIndex) {
      settings.setBottomNavIndex(newIndex);
      settings.flushStack(); //Only clever boys can do this:D

    } else if (!isEmpty()) {
      settings.setBottomNavIndex(newIndex);
      settings.flushStack(); //Only clever boys can do this:D
    }
  }
}
