import 'package:eventizer/Services/NavigationProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavigationManager {
  late NavigationProvider nav;

  /*
  NOTE stackPage e sayfa eklemek için istediğin yerde bunu çağır :: NavigationManager(context).pushPage(Widget)
  NOTE geri gelmek için bunu çağır :: NavigationManager(context).popPage();
  */

  NavigationManager(BuildContext context) {
    nav = Provider.of<NavigationProvider>(context, listen: false);
  }

  bool onBackButtonPressed() {
    if (nav.getBottomNavIndex() == 1 &&
        nav.getCreateEventPageController().page == 1) {
      nav.getCreateEventPageController().previousPage(
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
      nav.getCreateEventPageController();

  bool isEmpty() {
    return nav.getPageStack().isEmpty;
  }

  Widget? getLastPage() {
    if (isEmpty()) {
      return null;
    } else
      return nav.getPageStack().last;
  }

  void popPage() {
    if (!isEmpty()) {
      nav.popPage();
    }
  }

  void pushPage(Widget page, {bool refresh = true}) {
    nav.pushPage(page);
    if (refresh) nav.refresh();
  }

  int getBottomNavIndex() {
    return nav.getBottomNavIndex();
  }

  void setBottomNavIndex(int newIndex) {
    if (nav.getBottomNavIndex() != newIndex) {
      nav.setBottomNavIndex(newIndex);
      nav.flushStack(); //Only clever boys can do this:D

    } else if (!isEmpty()) {
      nav.setBottomNavIndex(newIndex);
      nav.flushStack(); //Only clever boys can do this:D
    }
  }
}
