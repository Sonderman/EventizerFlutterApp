import 'package:get/get.dart';

// Home page controller for GetX state management
class HomeController extends GetxController {
  // Bottom navigation index
  final _bottomNavIndex = 2.obs; // Default to explore page

  // Getters
  int get bottomNavIndex => _bottomNavIndex.value;

  // Setters
  void setBottomNavIndex(int index) {
    _bottomNavIndex.value = index;
  }
}
