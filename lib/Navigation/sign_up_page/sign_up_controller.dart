import 'dart:typed_data';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/services/auth_service.dart';
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
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Observable variables
  final Rx<Uint8List?> profileImage = Rx<Uint8List?>(null);
  final RxString birthday = ''.obs;
  final RxnBool isMale = RxnBool(null);
  final RxBool isLoading = false.obs;
  final RxBool showPassword = true.obs;

  /// Alan bazlı hata mesajları — her alanın altında inline gösterilir.
  /// Anahtar: 'name' | 'surname' | 'email' | 'password' | 'passwordConfirm'
  ///         | 'phone' | 'birthday' | 'gender' | 'profileImage'
  final RxMap<String, String> fieldErrors = <String, String>{}.obs;

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

  /// Alan adına göre hata metnini döndürür (inline gösterim için).
  String? errorFor(String field) => fieldErrors[field];

  void _clearError(String field) {
    if (fieldErrors.containsKey(field)) fieldErrors.remove(field);
  }

  /// Pick image from gallery or camera
  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        profileImage.value = await image.readAsBytes();
        _clearError('profileImage');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Fotoğraf seçilemedi: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Show image source selection dialog
  void showImagePickerDialog() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E2E47),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Fotoğraf Kaynağı Seç',
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: 2.h,
                  color: MyColors.globalTextColor,
                ),
              ),
              SizedBox(height: 2.h),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: MyColors.globalTextColor,
                ),
                visualDensity: VisualDensity.compact,
                title: Text(
                  'Galeri',
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 2.h,
                    color: MyColors.globalTextColor,
                  ),
                ),
                onTap: () async {
                  Get.back();
                  await pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: MyColors.globalTextColor,
                ),
                visualDensity: VisualDensity.compact,
                title: Text(
                  'Kamera',
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 2.h,
                    color: MyColors.globalTextColor,
                  ),
                ),
                onTap: () async {
                  Get.back();
                  await pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Cinsiyet seçimi — seçim yapılınca alan hatası temizlenir.
  void selectGender(bool male) {
    isMale.value = male;
    _clearError('gender');
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
      _clearError('birthday');
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
        nameController.text.trim(),
        surnameController.text.trim(),
        emailController.text.trim(),
        phoneController.text.trim(),
        // Cinsiyet artık zorunlu — null olamaz (validateForm kontrol ediyor)
        isMale.value! == true ? "Man" : "Woman",
        birthday.value,
        generateNickname(nameController.text.trim()),
      ];

      final userID = await userService!.registerUser(
        emailController.text.trim(),
        passwordController.text,
        dataList,
        profileImage.value!,
      );

      if (userID != null) {
        final isInitialized = await userService!.userInitializer(userID);
        if (!isInitialized) {
          throw Exception('User profile could not be loaded after signup');
        }
        Fluttertoast.showToast(
          msg:
              "Hesabınız başarıyla oluşturuldu. Lütfen mailinizi doğrulayınız.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 18.0,
        );
        Get.back();
        navigateToLogin();
      } else {
        throw Exception('Signup failed');
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Kayıt başarısız: ${AuthService.authErrorMessage(e)}",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Basit e-posta format kontrolü.
  static final RegExp _emailRegex = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');

  /// Validate form fields — tost yerine her alanın altında inline hata.
  bool validateForm() {
    fieldErrors.clear();

    // Profil fotoğrafı zorunlu
    if (profileImage.value == null) {
      fieldErrors['profileImage'] = 'Lütfen bir profil fotoğrafı seçin';
    }

    // Ad / Soyad
    if (nameController.text.trim().isEmpty) {
      fieldErrors['name'] = 'Adınızı girin';
    }
    if (surnameController.text.trim().isEmpty) {
      fieldErrors['surname'] = 'Soyadınızı girin';
    }

    // E-posta — boş + format
    final email = emailController.text.trim();
    if (email.isEmpty) {
      fieldErrors['email'] = 'E-posta adresinizi girin';
    } else if (!_emailRegex.hasMatch(email)) {
      fieldErrors['email'] = 'Geçerli bir e-posta adresi girin';
    }

    // Şifre — boş + minimum uzunluk
    if (passwordController.text.isEmpty) {
      fieldErrors['password'] = 'Şifrenizi girin';
    } else if (passwordController.text.length < 6) {
      fieldErrors['password'] = 'Şifre en az 6 karakter olmalı';
    }

    // Şifre tekrarı
    if (passwordConfirmController.text.isEmpty) {
      fieldErrors['passwordConfirm'] = 'Şifrenizi tekrar girin';
    } else if (passwordController.text != passwordConfirmController.text) {
      fieldErrors['passwordConfirm'] = 'Şifreler eşleşmiyor';
    }

    // Telefon — dolu ise geçerlilik kontrolü
    final phone = phoneController.text.trim();
    if (phone.isNotEmpty && int.tryParse(phone) == null) {
      fieldErrors['phone'] = 'Geçerli bir telefon numarası girin';
    }

    // Cinsiyet artık zorunlu — varsayılan "Woman" tuzağı kapalı
    if (isMale.value == null) {
      fieldErrors['gender'] = 'Lütfen cinsiyetinizi seçin';
    }

    // Doğum tarihi
    if (birthday.value.isEmpty) {
      fieldErrors['birthday'] = 'Lütfen doğum tarihinizi seçin';
    }

    return fieldErrors.isEmpty;
  }

  /// Navigate back to login
  void navigateToLogin() {
    pageController.previousPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
    );
  }
}