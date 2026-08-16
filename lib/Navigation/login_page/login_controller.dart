import 'package:eventizer/locator.dart';
import 'package:eventizer/navigation/home_page/home_page.dart';
import 'package:eventizer/services/auth_service.dart';
import 'package:eventizer/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  final RxBool isPasswordVisible = true.obs;
  final RxBool isShowLogin = false.obs;
  final RxString sendPasswordMailText = "Login".obs;

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
    try {
      isLoading.value = true;
      var auth = locator<AuthService>();

      final result = await auth.signIn(
        emailController.text,
        passwordController.text,
      );

      if (result == null) {
        isLoading.value = false;
        Fluttertoast.showToast(
          msg: "Wrong password or email!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 18.0,
        );
      } else {
        userId.value = result;
        await userService!.userInitializer(result);
        await userService!.updateSingleInfo("LastLoggedIn", "timeStamp");

        // Navigate to home page using GetX navigation
        Get.offAll(() => const HomePage());
      }
    } catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Handle forget password functionality
  void forgetPassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
    sendPasswordMailText.value = "Send Password";
    isShowLogin.value = true;
  }

  /// Send password reset email
  Future<void> passwordReset() async {
    try {
      var auth = locator<AuthService>();
      // TODO: Uncomment when releasing
      // await auth.sendPasswordResetEmail(emailController.text);
      debugPrint("Şifre sıfırlama maili gönderildi");

      Fluttertoast.showToast(
        msg: "Şifre sıfırlama maili gönderildi",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred while sending the password reset email",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Handle remember password functionality
  void rememberPassword() {
    if (isPasswordVisible.value == false) {
      sendPasswordMailText.value = "Login";
      isPasswordVisible.value = true;
      isShowLogin.value = false;
    }
  }

  /// Navigate to signup page
  void navigateToSignUp() {
    pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  /// Handle main action button press (login or password reset)
  void handleMainAction() {
    if (isPasswordVisible.value == true) {
      loginButton();
    } else {
      passwordReset();
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    // This will be handled by a separate observable in the password field
  }
}
