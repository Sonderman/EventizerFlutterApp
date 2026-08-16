import 'package:eventizer/navigation/chat_page.dart';
import 'package:eventizer/navigation/explore_event_page.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/navigation/create_event_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:eventizer/tools/navigation_manager.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget getNavigatedPage(BuildContext context) {
  //ANCHOR stack de widget varsa o sayfayı döndürür yoksa default veya mevcut indexe göre sayfayı açar
  if (NavigationManager(context).getLastPage() != null) {
    return NavigationManager(context).getLastPage()!;
  } else {
    UserService userWorker = Provider.of<UserService>(context);
    List<Widget> pages = [
      const ChatPage(),
      const CreateEventPage(),
      const ExploreEventPage(),
      ProfilePage(key: UniqueKey(), userID: userWorker.userModel!.getUserId(), isFromEvent: false),
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
    inactiveIconColor: MyColors.purpleContainer,
    circleColor: MyColors.purpleContainer,
    tabs: [
      TabData(iconData: Icons.chat, title: "Chat", onclick: currentPageSetter),
      TabData(iconData: Icons.add, title: "Oluştur", onclick: currentPageSetter),
      TabData(iconData: Icons.search, title: "Keşfet", onclick: currentPageSetter),
      TabData(iconData: Icons.assignment_ind, title: "Profil", onclick: currentPageSetter),
    ],
    onTabChangedListener: (position) {
      currentPosition = position;
      navigation.setBottomNavIndex(position);
    },
  );
}
