import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/components/glass_action_button.dart';
import 'package:eventizer/components/glass_inputs.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:sizer/sizer.dart';
import '../../Navigation/components/custom_scroll.dart';
import 'sign_up_controller.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage(this.pageController, {super.key});
  final PageController pageController;

  /// Inline hata metni — alan altında, cam üstünde okunur kırmızı.
  Widget _errorText(String field) {
    return Obx(() {
      final String? error = controller.errorFor(field);
      if (error == null) return const SizedBox.shrink();
      return Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: Text(
          error,
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: 12.sp,
            color: Colors.redAccent,
            shadows: const [Shadow(color: Color(0x8A000000), blurRadius: 6, offset: Offset(0, 1))],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(pageController),
      builder: (controller) => Obx(
        () => controller.isLoading.value
            ? const Loading()
            : SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GlassCard(
                    shape: const LiquidRoundedSuperellipse(borderRadius: 30),
                    padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.h),
                    settings: MyLiquidGlass.overlay,
                    useOwnLayer: true,
                    child: ScrollConfiguration(
                      behavior: NoScrollEffectBehavior(),
                      child: SingleChildScrollView(
                        child: AutofillGroup(
                          child: Column(
                            children: <Widget>[
                              addPhoto(context),
                              // Fotoğraf hata metni — halkanın hemen altında
                              _errorText('profileImage'),
                              SizedBox(height: 2.h),
                              nameSurname(),
                              SizedBox(height: 2.h),
                              GlassInputField(
                                controller: controller.emailController,
                                hint: "E-posta*",
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
                              ),
                              _errorText('email'),
                              SizedBox(height: 2.h),
                              passwordFields(),
                              SizedBox(height: 2.h),
                              phoneField(),
                              SizedBox(height: 2.h),
                              countryAndBirthDate(),
                              _errorText('birthday'),
                              SizedBox(height: 2.h),
                              selectGender(),
                              _errorText('gender'),
                              SizedBox(height: 3.h),
                              signUpButton(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  /// Profil fotoğrafı seçici — cyan→mor gradient ince halka çevreler.
  Widget addPhoto(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: controller.showImagePickerDialog,
        child: Container(
          // Gradient halka: dıştaki ince çerçeve
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1BC8D9), Color(0xFF8358D8)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1BC8D9).withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 1,
              ),
            ],
          ),
          child: GlassContainer(
            shape: const LiquidOval(),
            padding: EdgeInsets.all(4.w),
            width: 32.w,
            height: 32.w,
            settings: MyLiquidGlass.interactive,
            useOwnLayer: true,
            child: Center(
              child: Obx(
                () => controller.profileImage.value == null
                    ? Icon(Icons.person_add_alt_1, size: 14.w, color: Colors.white)
                    : ClipOval(
                        child: Image.memory(controller.profileImage.value!, width: 32.w, height: 32.w, fit: BoxFit.cover),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget nameSurname() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: GlassInputField(
                controller: controller.nameController,
                hint: "Ad*",
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: GlassInputField(
                controller: controller.surnameController,
                hint: "Soyad*",
                textInputAction: TextInputAction.next,
                onSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(child: _errorText('name')),
            SizedBox(width: 3.w),
            Expanded(child: _errorText('surname')),
          ],
        ),
      ],
    );
  }

  Widget passwordFields() {
    return Column(
      children: <Widget>[
        GlassPasswordInput(
          controller: controller.passwordController,
          hint: "Şifre*",
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
        ),
        _errorText('password'),
        SizedBox(height: 2.h),
        GlassPasswordInput(
          controller: controller.passwordConfirmController,
          hint: "Şifre Tekrar*",
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => controller.signUp(),
        ),
        _errorText('passwordConfirm'),
      ],
    );
  }

  Widget phoneField() {
    return Column(
      children: <Widget>[
        GlassInputField(
          controller: controller.phoneController,
          hint: "Telefon Numarası",
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          maxLength: 10,
          // Sol tarafta ülke kodu ipucu
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Center(
              child: Text(
                "+90",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: 14.sp,
                  color: Colors.white.withValues(alpha: 0.72),
                ),
              ),
            ),
          ),
        ),
        _errorText('phone'),
      ],
    );
  }

  Widget countryAndBirthDate() {
    return GlassActionButton(
      label: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.calendar_month, size: 22, color: Colors.white),
            SizedBox(width: 2.w),
            Text(
              controller.birthday.value.isNotEmpty
                  ? "Doğum Tarihi: ${controller.birthday.value}"
                  : "Doğum Tarihiniz",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
      onTap: controller.selectBirthday,
    );
  }

  Widget selectGender() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Obx(
            () => _genderChip(
              label: "Erkek",
              selected: controller.isMale.value == true,
              tint: const Color(0x124A90E2),
              onTap: () => controller.selectGender(true),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Obx(
            () => _genderChip(
              label: "Kadın",
              selected: controller.isMale.value == false,
              tint: const Color(0x12B968C7),
              onTap: () => controller.selectGender(false),
            ),
          ),
        ),
      ],
    );
  }

  /// Cinsiyet seçimi — seçiliyken hafif renk tint'li net cam, değilken şeffaf.
  Widget _genderChip({
    required String label,
    required bool selected,
    required Color tint,
    required VoidCallback onTap,
  }) {
    return GlassChip(
      label: label,
      selected: selected,
      selectedColor: Colors.transparent,
      onTap: onTap,
      labelStyle: TextStyle(
        fontFamily: "Zona",
        fontSize: 16.sp,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      padding: EdgeInsets.symmetric(vertical: 2.h),
      useOwnLayer: true,
      settings: selected
          ? LiquidGlassSettings(
              blur: 0,
              thickness: 11,
              glassColor: tint,
              lightAngle: 0.75 * 3.141592653589793,
              lightIntensity: 0.98,
              ambientStrength: 0.18,
              saturation: 1.0,
              chromaticAberration: 0.01,
              specularSharpness: GlassSpecularSharpness.medium,
            )
          : MyLiquidGlass.interactive,
    );
  }

  Widget signUpButton() {
    return Obx(
      () => Row(
        children: <Widget>[
          Expanded(
            child: GlassActionButton(
              label: Text(
                "GERİ",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              onTap: controller.navigateToLogin,
              // Yükleme sırasında geri dönüş de kilitli (form yeniden açılır)
              enabled: !controller.isLoading.value,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: GlassActionButton(
              label: Text(
                "KAYDOL",
                style: TextStyle(
                  fontFamily: "Zona",
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
              onTap: controller.signUp,
              primary: true,
              enabled: !controller.isLoading.value,
            ),
          ),
        ],
      ),
    );
  }
}