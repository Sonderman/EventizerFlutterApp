import 'package:eventizer/navigation/chat_page.dart';
import 'package:eventizer/navigation/explore_event_page.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/navigation/create_event_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:eventizer/navigation/home_page/home_controller.dart';
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
  final UserService userWorker = Provider.of<UserService>(context);

  return Obx(() {
    final int currentPosition = homeController.bottomNavIndex;
    final String? profileUrl = userWorker.userModel?.getUserProfilePhotoUrl();
    final List<_GeneratedNavItemData> navItems = <_GeneratedNavItemData>[
      const _GeneratedNavItemData(
        icon: Icons.chat_bubble_rounded,
        label: "Chat",
        badgeCount: 1,
      ),
      const _GeneratedNavItemData(icon: Icons.add_rounded, label: "Oluştur"),
      const _GeneratedNavItemData(icon: Icons.search_rounded, label: "Keşfet"),
      _GeneratedNavItemData(
        icon: Icons.person_outline_rounded,
        label: "Profil",
        profileImageUrl: profileUrl,
      ),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: Container(
          height: 98,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(46),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Color(0xFF1A2E45), Color(0xFF1E3852)],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.09),
              width: 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: const Color(0xFF0D1928).withValues(alpha: 0.65),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List<Widget>.generate(navItems.length, (int index) {
              final _GeneratedNavItemData item = navItems[index];
              final bool isActive = index == currentPosition;

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 8,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(34),
                      onTap: () => _onTabSelected(index, homeController),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        curve: Curves.easeOutCubic,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(34),
                          color: isActive
                              ? const Color(0xFF183A5B).withValues(alpha: 0.85)
                              : Colors.transparent,
                          boxShadow: isActive
                              ? <BoxShadow>[
                                  BoxShadow(
                                    // Generated shadow layer: active tab visual emphasis.
                                    color: const Color(
                                      0xFF2C8BDE,
                                    ).withValues(alpha: 0.2),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : <BoxShadow>[],
                        ),
                        child: _GeneratedBottomNavItem(
                          data: item,
                          isActive: isActive,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  });
}

class _GeneratedNavItemData {
  final IconData icon;
  final String label;
  final int badgeCount;
  final String? profileImageUrl;

  const _GeneratedNavItemData({
    required this.icon,
    required this.label,
    this.badgeCount = 0,
    this.profileImageUrl,
  });
}

class _GeneratedBottomNavItem extends StatelessWidget {
  final _GeneratedNavItemData data;
  final bool isActive;

  const _GeneratedBottomNavItem({required this.data, required this.isActive});

  bool get _showProfileImage {
    return data.profileImageUrl != null &&
        data.profileImageUrl!.isNotEmpty &&
        data.profileImageUrl != 'null';
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = const Color(0xFF31A2FF);
    final Color inactiveColor = Colors.white.withValues(alpha: 0.85);
    final Color iconColor = isActive ? activeColor : inactiveColor;
    final Color labelColor = isActive
        ? activeColor
        : Colors.white.withValues(alpha: 0.93);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double iconSize = constraints.maxHeight * 0.34;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: iconSize + 8,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: <Widget>[
                  _showProfileImage
                      ? Container(
                          width: iconSize + 4,
                          height: iconSize + 4,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? activeColor.withValues(alpha: 0.75)
                                  : Colors.white.withValues(alpha: 0.4),
                              width: 1.4,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              data.profileImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  data.icon,
                                  size: iconSize,
                                  color: iconColor,
                                );
                              },
                            ),
                          ),
                        )
                      : Icon(data.icon, size: iconSize, color: iconColor),
                  if (data.badgeCount > 0)
                    Positioned(
                      top: -2,
                      right: -3,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B9AF6),
                          borderRadius: BorderRadius.circular(11),
                          border: Border.all(
                            color: const Color(0xFF1A2E45),
                            width: 1.5,
                          ),
                        ),
                        child: Text(
                          data.badgeCount.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "Zona",
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: labelColor,
                fontFamily: "Zona",
                fontSize: isActive ? 14 : 13,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
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
