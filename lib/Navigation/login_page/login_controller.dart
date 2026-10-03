import 'package:eventizer/locator.dart';
import 'package:eventizer/navigation/home_page/home_page.dart';
import 'package:eventizer/services/auth_service.dart';
import 'package:eventizer/services/repository.dart';
import 'package:eventizer/utils/navigation_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Text editing controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Page controller for navigation between login and signup
  late PageController pageController;

  // Observable variables
  final RxString userId = RxString('');
  final RxString errorText = RxString('');
  final RxBool isLoading = false.obs;

  // User service
  UserService? userService;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
    // Initialize user service from dependency injection
    userService = Get.find<UserService>();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    pageController.dispose();
    super.onClose();
  }

  /// Handle login button press
  Future<void> loginButton() async {
    // Boş alan kontrolü — ekrandaki hata metnini kullan (toast değil).
    if (emailController.text.trim().isEmpty) {
      errorText.value = 'E-posta adresinizi girin';
      return;
    }
    if (passwordController.text.isEmpty) {
      errorText.value = 'Şifrenizi girin';
      return;
    }
    errorText.value = '';

    try {
      isLoading.value = true;
      var auth = locator<AuthService>();

      final result = await auth.signIn(
        emailController.text.trim(),
        passwordController.text,
      );
      userId.value = result;

      // E-posta doğrulanmamışsa girişe izin verme — kullanıcıya doğrulama
      // maili gönder, oturumu kapat (Firebase oturum açtığı için).
      if (auth.isEmailVerified() != true) {
        await auth.sendEmailVerification();
        await auth.signOut();
        isLoading.value = false;
        errorText.value =
            'E-postanız henüz doğrulanmamış. Doğrulama maili tekrar gönderildi — lütfen gelen kutunuzu kontrol edin.';
        return;
      }

      await userService!.userInitializer(result);
      await userService!.updateSingleInfo("LastLoggedIn", "timeStamp");

      // Navigate to home page using GetX navigation
      Get.offAll(() => const HomePage());
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      errorText.value = AuthService.authErrorMessage(e);
    } catch (e) {
      isLoading.value = false;
      errorText.value = AuthService.authErrorMessage(e);
    }
  }

  /// Navigate to signup page
  void navigateToSignUp() {
    pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Şifre sıfırlama artık ayrı sayfada — NavigationUtils üzerinden.
  void goToForgetPassword() {
    NavigationUtils.toForgotPassword();
  }
}