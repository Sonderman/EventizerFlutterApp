import 'package:get/get.dart';
import 'package:eventizer/navigation/components/splash_screen.dart';
import 'package:eventizer/navigation/login_page/login_page_view.dart';
import 'package:eventizer/navigation/forget_pass_page.dart';
import 'package:eventizer/navigation/home_page/home_page.dart';
import 'package:eventizer/navigation/chat_page.dart';
import 'package:eventizer/navigation/create_event_page.dart';
import 'package:eventizer/navigation/explore_event_page.dart';
import 'package:eventizer/navigation/profile_page.dart';
import 'package:eventizer/navigation/my_events_page.dart';
import 'package:eventizer/navigation/settings_page.dart';
import 'package:eventizer/navigation/edit_profile_page.dart';
import 'package:eventizer/navigation/theme_settings_page.dart';
import 'package:eventizer/navigation/event_page.dart';
import 'package:eventizer/navigation/components/comments_page_details.dart';
import 'package:eventizer/routes/app_routes.dart';

// GetX pages configuration
class AppPages {
  static const String initial = AppRoutes.splash;

  static final routes = [
    // Splash Screen
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),

    // Authentication Pages
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),

      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgetPassword(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Main App Pages
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),

      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.chat,
      page: () => const ChatPage(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoutes.createEvent,
      page: () => const CreateEventPage(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoutes.exploreEvents,
      page: () => const ExploreEventPage(),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => ProfilePage(
        userID: Get.parameters['userId'] ?? '',
        isFromEvent: Get.parameters['isFromEvent'] == 'true',
      ),
      transition: Transition.noTransition,
    ),

    GetPage(
      name: AppRoutes.myEvents,
      page: () =>
          MyEventsPage(userID: Get.parameters['userId'], isOld: Get.parameters['isOld'] == 'true'),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.editProfile,
      page: () => const EditProfilePage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.themeSettings,
      page: () => const ThemeSettingsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    // Event Pages
    GetPage(
      name: AppRoutes.eventPage,
      page: () => EventPage(
        eventData: Get.arguments?['eventData'],
        userData: Get.arguments?['userData'],
        amIparticipant: Get.arguments?['amIparticipant'],
      ),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),

    GetPage(
      name: AppRoutes.commentsDetails,
      page: () => ProfileListItem(jsonData: Get.arguments?['jsonData']),
      transition: Transition.upToDown,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
