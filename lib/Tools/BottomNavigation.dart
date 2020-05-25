import 'package:eventizer/Navigation/ChatPage.dart';
import 'package:eventizer/Navigation/CreateEventPage.dart';
import 'package:eventizer/Navigation/ExploreEventPage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Navigation/SignupPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Tools/NavigationManager.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget getNavigatedPage(BuildContext context) {
  //ANCHOR stack de widget varsa o sayfayı döndürür yoksa default veya mevcut indexe göre sayfayı açar
  if (NavigationManager(context).getLastPage() != null) {
    return NavigationManager(context).getLastPage();
  } else {
    UserService userWorker = Provider.of<UserService>(context);
    List<Widget> pages = [
      ChatPage(),
      CreateEventPage(),
      LoginPage(),
      ProfilePage(userID: userWorker.usermodel.getUserId(), isFromEvent: false),
    ];
    return pages[NavigationManager(context).getBottomNavIndex()];
  }
}

Widget bottomNavigationBar(BuildContext context) {
  NavigationManager navigation = NavigationManager(context);
  int currentPosition = navigation.getBottomNavIndex();

  currentPageSetter() {
    navigation.setBottomNavIndex(currentPosition);
  }

  return FancyBottomNavigation(
    initialSelection: currentPosition,
    inactiveIconColor: MyColors().purpleContainer,
    circleColor: MyColors().purpleContainer,
    tabs: [
      TabData(iconData: Icons.chat, title: "Chat", onclick: currentPageSetter),
      TabData(
          iconData: Icons.add, title: "Oluştur", onclick: currentPageSetter),
      TabData(
          iconData: Icons.search, title: "Keşfet", onclick: currentPageSetter),
      TabData(
          iconData: Icons.assignment_ind,
          title: "Profil",
          onclick: currentPageSetter),
    ],
    onTabChangedListener: (position) {
      currentPosition = position;
      navigation.setBottomNavIndex(position);
    },
  );
}
