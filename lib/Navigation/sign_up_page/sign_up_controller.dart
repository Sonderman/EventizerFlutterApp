import 'dart:typed_data';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/services/repository.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class SignUpController extends GetxController {
  // Form controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Observable variables
  final Rx<Uint8List?> profileImage = Rx<Uint8List?>(null);
  final RxString birthday = ''.obs;
  final RxnBool isMale = RxnBool(null);
  final RxBool isLoading = false.obs;
  final RxBool showPassword = true.obs;

  // User service
  UserService? userService;
  final PageController pageController;
  SignUpController(this.pageController);

  @override
  void onInit() {
    super.onInit();
    userService = Get.find<UserService>();
  }

  @override
  void onClose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  /// Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      profileImage.value = await image.readAsBytes();
    }
  }

  /// Show image source selection dialog
  void showImagePickerDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.transparent,
        content: MyLiquidGlass.standartDialog(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 2.h,
              children: [
                Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 2.h,
                    color: MyColors.globalTextColor,
                  ),
                ),
                MyLiquidGlass.standartButton(
                  child: ListTile(
                    leading: Icon(Icons.photo_library, color: MyColors.globalTextColor),
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      'Gallery',
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: 2.h,
                        color: MyColors.globalTextColor,
                      ),
                    ),
                    onTap: () {
                      pickImage(ImageSource.gallery);
                      Get.back();
                    },
                  ),
                ),
                MyLiquidGlass.standartButton(
                  child: ListTile(
                    leading: Icon(Icons.camera_alt, color: MyColors.globalTextColor),
                    visualDensity: VisualDensity.compact,
                    title: Text(
                      'Camera',
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: 2.h,
                        color: MyColors.globalTextColor,
                      ),
                    ),
                    onTap: () {
                      pickImage(ImageSource.camera);
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Select birth date
  Future<void> selectBirthday() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 70)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (picked != null) {
      // Format the birthday as DD/MM/YYYY with leading zeros for day and month
      birthday.value =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
    }
  }

  /// Generate random nickname
  String generateNickname(String name) {
    return name + (DateTime.now().millisecondsSinceEpoch % 10000).toString();
  }

  /// Handle signup process
  Future<void> signUp() async {
    if (!validateForm()) return;

    isLoading.value = true;

    try {
      // Create user data list
      List<String> dataList = [
        nameController.text,
        surnameController.text,
        emailController.text,
        phoneController.text,
        isMale.value == true ? "Man" : "Woman",
        birthday.value,
        generateNickname(nameController.text),
      ];

      final userID = await userService!.registerUser(
        emailController.text,
        passwordController.text,
        dataList,
        profileImage.value!,
      );

      if (userID != null) {
        await userService!.userInitializer(userID);
        Fluttertoast.showToast(
          msg: "Hesabınız başarıyla oluşturuldu. Lütfen mailinizi doğrulayınız.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        Get.back();
      } else {
        throw Exception('Signup failed');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Signup failed: $e", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate form fields
  bool validateForm() {
    if (profileImage.value == null) {
      Fluttertoast.showToast(msg: 'Please select a profile image', backgroundColor: Colors.red);
      return false;
    }
    if (nameController.text.isEmpty || surnameController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter name and surname', backgroundColor: Colors.red);
      return false;
    }
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter email and password', backgroundColor: Colors.red);
      return false;
    }
    if (passwordController.text != passwordConfirmController.text) {
      Fluttertoast.showToast(msg: 'Passwords do not match', backgroundColor: Colors.red);
      return false;
    }
    if (birthday.value.isEmpty) {
      Fluttertoast.showToast(msg: 'Please select birthday', backgroundColor: Colors.red);
      return false;
    }
    return true;
  }

  /// Navigate back to login
  void navigateToLogin() {
    pageController.previousPage(duration: const Duration(seconds: 1), curve: Curves.easeInOutCubic);
  }
}
