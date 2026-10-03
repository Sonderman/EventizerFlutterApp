import 'package:eventizer/navigation/chat_page.dart';
import 'package:eventizer/navigation/explore_event_page.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/navigation/create_event_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:eventizer/navigation/home_page/home_controller.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
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

/// Alt navigasyon — liquid_glass_widgets paketinin [GlassTabBar.bottom]'u.
/// Cam pin: net cam (blur=0) + seçili sekmede cyan jelly indicator.
/// Badge ve profil avatarı korunur.
Widget getXBottomNavigationBar(BuildContext context) {
  final HomeController homeController = Get.find<HomeController>();
  final UserService userWorker = Provider.of<UserService>(context);

  const Color cyan = Color(0xFF1BC8D9);

  return Obx(() {
    final int currentPosition = homeController.bottomNavIndex;
    final String? profileUrl = userWorker.userModel?.getUserProfilePhotoUrl();
    final bool showProfileImage =
        profileUrl != null && profileUrl.isNotEmpty && profileUrl != 'null';

    final List<GlassTab> tabs = <GlassTab>[
      // Chat — sabit badge (eski davranış korunur)
      GlassTab(
        label: "Chat",
        glowColor: cyan,
        icon: const GlassBadge(
          count: 1,
          backgroundColor: Color(0xFF2B9AF6),
          textColor: Colors.white,
          child: Icon(Icons.chat_bubble_rounded, size: 24),
        ),
        activeIcon: const GlassBadge(
          count: 1,
          backgroundColor: Color(0xFF2B9AF6),
          textColor: Colors.white,
          child: Icon(Icons.chat_bubble_rounded, size: 24),
        ),
      ),
      const GlassTab(
        label: "Oluştur",
        glowColor: cyan,
        icon: Icon(Icons.add_rounded, size: 24),
        activeIcon: Icon(Icons.add_rounded, size: 24),
      ),
      const GlassTab(
        label: "Keşfet",
        glowColor: cyan,
        icon: Icon(Icons.search_rounded, size: 24),
        activeIcon: Icon(Icons.search_rounded, size: 24),
      ),
      GlassTab(
        label: "Profil",
        glowColor: cyan,
        icon: _ProfileTabIcon(
          showImage: showProfileImage,
          url: profileUrl,
        ),
        activeIcon: _ProfileTabIcon(
          showImage: showProfileImage,
          url: profileUrl,
        ),
      ),
    ];

    return GlassTabBar.bottom(
      tabs: tabs,
      selectedIndex: currentPosition,
      onTabSelected: (index) => homeController.setBottomNavIndex(index),
      // Net cam — app genelindeki MyLiquidGlass.overlay ile aynı dil
      settings: MyLiquidGlass.overlay,
      indicatorColor: cyan.withValues(alpha: 0.9),
      selectedIconColor: Colors.white,
      unselectedIconColor: Colors.white.withValues(alpha: 0.80),
      selectedLabelColor: Colors.white,
      unselectedLabelColor: Colors.white.withValues(alpha: 0.80),
      selectedLabelStyle: const TextStyle(
        fontFamily: "Zona",
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: "Zona",
        fontWeight: FontWeight.w500,
      ),
      iconSize: 24,
      labelFontSize: 12,
      barHeight: 72,
      horizontalPadding: 14,
      verticalPadding: 12,
      magnification: 1.12,
    );
  });
}

/// Profil sekmesi ikonu — kullanıcı fotoğrafı varsa avatar, yoksa ikon.
class _ProfileTabIcon extends StatelessWidget {
  const _ProfileTabIcon({required this.showImage, required this.url});

  final bool showImage;
  final String? url;

  @override
  Widget build(BuildContext context) {
    final double avatarSize = 26;
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF1BC8D9).withValues(alpha: 0.55),
          width: 1.2,
        ),
      ),
      child: ClipOval(
        child: showImage
            ? Image.network(
                url!,
                fit: BoxFit.cover,
                // Fotoğraf yüklenemezse ikon fallback (eski davranış)
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person_outline_rounded,
                  size: 24,
                  color: Colors.white,
                ),
              )
            : const Icon(
                Icons.person_outline_rounded,
                size: 24,
                color: Colors.white,
              ),
      ),
    );
  }
}