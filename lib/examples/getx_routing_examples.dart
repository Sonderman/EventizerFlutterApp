import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eventizer/utils/navigation_utils.dart';
import 'package:eventizer/routes/app_routes.dart';
import 'package:eventizer/navigation/home_page/home_controller.dart';

// Examples of how to use GetX routing system in the Eventizer app
class GetXRoutingExamples {
  // BASIC NAVIGATION EXAMPLES

  // 1. Simple navigation to a page
  static void navigateToLoginExample() {
    NavigationUtils.toLogin();
    // or directly: Get.toNamed(AppRoutes.login);
  }

  // 2. Navigation with parameters
  static void navigateToProfileExample() {
    NavigationUtils.toProfile(userId: "user123", isFromEvent: true);
  }

  // 3. Navigation with complex arguments
  static void navigateToEventPageExample() {
    NavigationUtils.toEventPage(
      eventData: {'eventID': 'event123', 'title': 'Sample Event', 'date': '2024-01-15'},
      userData: {'UserID': 'user123', 'Name': 'John Doe'},
      amIparticipant: true,
    );
  }

  // 4. Replace all previous routes (like login to home)
  static void navigateToHomeAfterLoginExample() {
    NavigationUtils.toHome(); // Uses Get.offAllNamed internally
  }

  // BOTTOM NAVIGATION EXAMPLES

  // 5. Change bottom navigation tab programmatically
  static void changeBottomNavTabExample() {
    NavigationUtils.changeBottomNavTab(2); // Navigate to explore tab
  }

  // BACK NAVIGATION EXAMPLES

  // 6. Simple back navigation
  static void goBackExample() {
    NavigationUtils.back();
    // or directly: Get.back();
  }

  // 7. Back to specific route
  static void backToSpecificRouteExample() {
    NavigationUtils.backUntil(AppRoutes.home);
    // or directly: Get.until((route) => route.settings.name == AppRoutes.home);
  }

  // DIALOG AND SNACKBAR EXAMPLES

  // 8. Show success message
  static void showSuccessMessageExample() {
    NavigationUtils.showSnackbar(
      title: "Başarılı",
      message: "İşlem başarıyla tamamlandı",
      isError: false,
    );
  }

  // 9. Show error message
  static void showErrorMessageExample() {
    NavigationUtils.showSnackbar(title: "Hata", message: "Bir hata oluştu", isError: true);
  }

  // 10. Show custom dialog
  static void showCustomDialogExample(BuildContext context) {
    NavigationUtils.showDialog(
      AlertDialog(
        title: const Text("Onay"),
        content: const Text("Bu işlemi yapmak istediğinizden emin misiniz?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Hayır")),
          TextButton(
            onPressed: () {
              Get.back();
              // Perform action
            },
            child: const Text("Evet"),
          ),
        ],
      ),
    );
  }

  // 11. Show bottom sheet
  static void showBottomSheetExample() {
    NavigationUtils.showBottomSheet(
      Container(
        height: 200,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Seçenekler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text("Düzenle"),
              onTap: () {
                Get.back();
                NavigationUtils.toEditProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Ayarlar"),
              onTap: () {
                Get.back();
                NavigationUtils.toSettings();
              },
            ),
          ],
        ),
      ),
    );
  }

  // USING GET DIRECTLY (Alternative approach)

  // 12. Direct GetX usage examples
  static void directGetXUsageExamples() {
    // Basic navigation
    Get.toNamed(AppRoutes.login);

    // Navigation with parameters
    Get.toNamed('${AppRoutes.profile}?userId=123&isFromEvent=true');

    // Navigation with arguments
    Get.toNamed(
      AppRoutes.eventPage,
      arguments: {
        'eventData': {'eventID': 'event123'},
        'userData': {'UserID': 'user123'},
        'amIparticipant': true,
      },
    );

    // Replace current route
    Get.offNamed(AppRoutes.home);

    // Replace all routes
    Get.offAllNamed(AppRoutes.home);

    // Back navigation
    Get.back();

    // Back with result
    Get.back(result: {'success': true});
  }

  // GETX CONTROLLER INTEGRATION EXAMPLES

  // 13. Using GetX controller in navigation
  static void getXControllerNavigationExample() {
    // Access controller
    final homeController = Get.find<HomeController>();

    // Change bottom navigation through controller
    homeController.setBottomNavIndex(1);

    // Navigate based on controller state
    if (homeController.bottomNavIndex == 0) {
      NavigationUtils.toChat();
    }
  }

  // ROUTE PARAMETERS AND ARGUMENTS ACCESS

  // 14. Accessing route parameters in destination page
  static void accessRouteParametersExample() {
    // In the destination page's build method or initState:

    // Access URL parameters
    String? userId = Get.parameters['userId'];
    bool isFromEvent = Get.parameters['isFromEvent'] == 'true';

    // Access arguments
    Map<String, dynamic>? eventData = Get.arguments?['eventData'];
    Map<String, dynamic>? userData = Get.arguments?['userData'];
    bool? amIparticipant = Get.arguments?['amIparticipant'];

    print('User ID: $userId');
    print('Is from event: $isFromEvent');
    print('Event data: $eventData');
  }

  // CONDITIONAL NAVIGATION EXAMPLES

  // 15. Conditional navigation based on app state
  static void conditionalNavigationExample() {
    // Check if user is logged in
    bool isLoggedIn = true; // Get from your auth service

    if (isLoggedIn) {
      NavigationUtils.toHome();
    } else {
      NavigationUtils.toLogin();
    }
  }

  // 16. Navigation with validation
  static void navigationWithValidationExample() {
    // Validate before navigation
    if (_validateForm()) {
      NavigationUtils.showSnackbar(title: "Başarılı", message: "Form kaydedildi");
      NavigationUtils.toHome();
    } else {
      NavigationUtils.showSnackbar(
        title: "Hata",
        message: "Lütfen tüm alanları doldurun",
        isError: true,
      );
    }
  }

  static bool _validateForm() {
    // Your validation logic here
    return true;
  }
}

// PRACTICAL USAGE IN WIDGETS

class ExampleUsageWidget extends StatelessWidget {
  const ExampleUsageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("GetX Routing Examples")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () => NavigationUtils.toLogin(),
            child: const Text("Login'e Git"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => NavigationUtils.toProfile(userId: "123"),
            child: const Text("Profile Git"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => GetXRoutingExamples.showSuccessMessageExample(),
            child: const Text("Başarı Mesajı Göster"),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => GetXRoutingExamples.showBottomSheetExample(),
            child: const Text("Bottom Sheet Göster"),
          ),
        ],
      ),
    );
  }
}
