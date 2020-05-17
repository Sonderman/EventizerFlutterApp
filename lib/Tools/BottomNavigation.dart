import 'package:eventizer/Navigation/ChatPage.dart';
import 'package:eventizer/Navigation/CreateEventPage.dart';
import 'package:eventizer/Navigation/ExploreEventPage.dart';
import 'package:eventizer/Navigation/Old/OldChatsPage.dart';
import 'package:eventizer/Navigation/Old/OldCreateEvent.dart';
import 'package:eventizer/Navigation/ProfilePage.dart';
import 'package:eventizer/Navigation/SettingsPage.dart';
import 'package:eventizer/Navigation/SignupPage.dart';
import 'package:eventizer/Services/Repository.dart';
import 'package:eventizer/assets/Colors.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<Widget> bottomPages(BuildContext context) {
  UserService userWorker = Provider.of<UserService>(context);
  return <Widget>[
    ChatPage(),
    //OldCreateEvent(),
    CreateEventPage(),
    ExploreEventPage(),
    ProfilePage(userID: userWorker.usermodel.getUserId(), isFromEvent: false),
    //SettingsPage()
    //SignupPage()
  ];
}

Widget bottomNavigationBar(int selectedIndex, BuildContext context,
    {Function setState}) {
  return FancyBottomNavigation(
    initialSelection: selectedIndex,
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
      setState(position);
    },
  );
}
