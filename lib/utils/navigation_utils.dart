import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:eventizer/routes/app_routes.dart';

// Navigation utility functions for GetX routing
class NavigationUtils {
  // Authentication navigation
  static void toLogin() {
    Get.toNamed(AppRoutes.login);
  }

  static void toForgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }

  // Main app navigation
  static void toHome() {
    Get.offAllNamed(AppRoutes.home);
  }

  static void toChat() {
    Get.toNamed(AppRoutes.chat);
  }

  static void toCreateEvent() {
    Get.toNamed(AppRoutes.createEvent);
  }

  static void toExploreEvents() {
    Get.toNamed(AppRoutes.exploreEvents);
  }

  static void toProfile({required String userId, bool isFromEvent = false}) {
    Get.toNamed('${AppRoutes.profile}?userId=$userId&isFromEvent=$isFromEvent');
  }

  static void toMyEvents({String? userId, bool isOld = false}) {
    String route = AppRoutes.myEvents;
    if (userId != null) {
      route += '?userId=$userId&isOld=$isOld';
    } else {
      route += '?isOld=$isOld';
    }
    Get.toNamed(route);
  }

  static void toSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  static void toEditProfile() {
    Get.toNamed(AppRoutes.editProfile);
  }

  // Event navigation
  static void toEventPage({
    Map<String, dynamic>? eventData,
    Map<String, dynamic>? userData,
    bool? amIparticipant,
  }) {
    Get.toNamed(
      AppRoutes.eventPage,
      arguments: {'eventData': eventData, 'userData': userData, 'amIparticipant': amIparticipant},
    );
  }

  static void toCommentsDetails({required Map<String, dynamic> jsonData}) {
    Get.toNamed(AppRoutes.commentsDetails, arguments: {'jsonData': jsonData});
  }

  // Bottom navigation helpers
  static void changeBottomNavTab(int index) {
    switch (index) {
      case 0:
        toChat();
        break;
      case 1:
        toCreateEvent();
        break;
      case 2:
        toExploreEvents();
        break;
      case 3:
        // Get current user ID from your user service
        // toProfile(userId: currentUserId, isFromEvent: false);
        break;
    }
  }

  // Navigation utilities
  static void back() {
    Get.back();
  }

  static void backUntil(String routeName) {
    Get.until((route) => route.settings.name == routeName);
  }

  static void offAll(String routeName) {
    Get.offAllNamed(routeName);
  }

  // Dialog and bottom sheet helpers
  static void showSnackbar({required String title, required String message, bool isError = false}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? const Color(0xFFE74C3C) : const Color(0xFF27AE60),
      colorText: const Color(0xFFFFFFFF),
      duration: const Duration(seconds: 3),
    );
  }

  static Future<T?> showBottomSheet<T>(Widget bottomSheet) {
    return Get.bottomSheet<T>(
      bottomSheet,
      backgroundColor: const Color(0xFFFFFFFF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }

  static Future<T?> showDialog<T>(Widget dialog) {
    return Get.dialog<T>(dialog);
  }
}
