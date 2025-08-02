import 'package:eventizer/navigation/chat_page.dart';
import 'package:eventizer/navigation/explore_event_page.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/navigation/create_event_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:eventizer/navigation/home_page/home_controller.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

// GetX compatible bottom navigation widget
Widget getXNavigatedPage(BuildContext context) {
  final HomeController homeController = Get.find<HomeController>();
  final UserService userWorker = Provider.of<UserService>(context);

  // List of pages for bottom navigation
  final List<Widget> pages = [
    const ChatPage(),
    const CreateEventPage(),
    const ExploreEventPage(),
    ProfilePage(
      key: UniqueKey(),
      userID: userWorker.userModel?.getUserId() ?? '',
      isFromEvent: false,
    ),
  ];

  return Obx(() => pages[homeController.bottomNavIndex]);
}

Widget getXBottomNavigationBar(BuildContext context) {
  final HomeController homeController = Get.find<HomeController>();

  return Obx(() {
    int currentPosition = homeController.bottomNavIndex;

    return FancyBottomNavigation(
      initialSelection: currentPosition,
      inactiveIconColor: MyColors.purpleContainer,
      circleColor: MyColors.purpleContainer,
      tabs: [
        TabData(
          iconData: Icons.chat,
          title: "Chat",
          onclick: () => _onTabSelected(0, homeController),
        ),
        TabData(
          iconData: Icons.add,
          title: "Oluştur",
          onclick: () => _onTabSelected(1, homeController),
        ),
        TabData(
          iconData: Icons.search,
          title: "Keşfet",
          onclick: () => _onTabSelected(2, homeController),
        ),
        TabData(
          iconData: Icons.assignment_ind,
          title: "Profil",
          onclick: () => _onTabSelected(3, homeController),
        ),
      ],
      onTabChangedListener: (position) {
        _onTabSelected(position, homeController);
      },
    );
  });
}

// Handle tab selection with GetX routing
void _onTabSelected(int index, HomeController homeController) {
  homeController.setBottomNavIndex(index);

  // Optional: Use actual navigation for tab changes
  // Uncomment if you want to use named routes for bottom navigation
  /*
  switch (index) {
    case 0:
      NavigationUtils.toChat();
      break;
    case 1:
      NavigationUtils.toCreateEvent();
      break;
    case 2:
      NavigationUtils.toExploreEvents();
      break;
    case 3:
      // Get current user ID and navigate to profile
      final userService = Get.find<UserService>();
      if (userService.userModel?.getUserId() != null) {
        NavigationUtils.toProfile(
          userId: userService.userModel!.getUserId(),
          isFromEvent: false,
        );
      }
      break;
  }
  */
}
