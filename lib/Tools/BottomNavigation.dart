import 'package:eventizer/Navigation/ChatPage.dart';
import 'package:eventizer/Navigation/CreateEventPage.dart';
import 'package:eventizer/Navigation/ExploreEventPage.dart';
import 'package:eventizer/Navigation/LoginPage.dart';
import 'package:eventizer/Navigation/Old/OldChatsPage.dart';
import 'package:eventizer/Navigation/Old/OldCreateEvent.dart';
import 'package:eventizer/Navigation/Old/OldLoginPage.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Navigation/SignupPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:eventizer/locator.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget getNavigatedPage(BuildContext context) {
  UserService userWorker = Provider.of<UserService>(context);
  List<Widget> pages = [
    ChatPage(),
    CreateEventPage(),
    ExploreEventPage(),
    ProfilePage(userID: userWorker.usermodel.getUserId(), isFromEvent: false),
    //SettingsPage()
  ];
  return pages[
      Provider.of<AppSettings>(context, listen: false).getBottomNavIndex()];
}

Widget bottomNavigationBar(BuildContext context) {
  return FancyBottomNavigation(
    initialSelection:
        Provider.of<AppSettings>(context, listen: false).getBottomNavIndex(),
    inactiveIconColor: MyColors().purpleContainer,
    circleColor: MyColors().purpleContainer,
    tabs: [
      TabData(
        iconData: Icons.chat,
        title: "Chat",
      ),
      TabData(
        iconData: Icons.add,
        title: "Oluştur",
      ),
      TabData(
        iconData: Icons.search,
        title: "Keşfet",
      ),
      TabData(
        iconData: Icons.assignment_ind,
        title: "Profil",
      ),
    ],
    onTabChangedListener: (position) {
      Provider.of<AppSettings>(context, listen: false)
          .setBottomNavIndex(position);
      //setState();
    },
  );
}
