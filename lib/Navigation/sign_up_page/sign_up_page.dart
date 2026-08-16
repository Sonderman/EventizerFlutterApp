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
                        child: Column(
                          children: <Widget>[
                            addPhoto(context),
                            SizedBox(height: 3.h),
                            nameSurname(),
                            SizedBox(height: 2.h),
                            GlassInputField(
                              controller: controller.emailController,
                              hint: "Email*",
                            ),
                            SizedBox(height: 2.h),
                            passwordFields(),
                            SizedBox(height: 2.h),
                            GlassInputField(
                              controller: controller.phoneController,
                              hint: "Phone Number",
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              maxLength: 10,
                            ),
                            SizedBox(height: 2.h),
                            countryAndBirthDate(),
                            SizedBox(height: 2.h),
                            selectGender(),
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
    );
  }

  Widget addPhoto(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: controller.showImagePickerDialog,
        child: GlassContainer(
          shape: const LiquidOval(),
          padding: EdgeInsets.all(5.w),
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
    );
  }

  Widget nameSurname() {
    return Row(
      children: <Widget>[
        Expanded(
          child: GlassInputField(
            controller: controller.nameController,
            hint: "Name*",
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: GlassInputField(
            controller: controller.surnameController,
            hint: "Surname*",
          ),
        ),
      ],
    );
  }

  Widget passwordFields() {
    return Column(
      children: <Widget>[
        GlassPasswordInput(
          controller: controller.passwordController,
          hint: "Password*",
        ),
        SizedBox(height: 2.h),
        GlassPasswordInput(
          controller: controller.passwordConfirmController,
          hint: "Password Confirm*",
        ),
      ],
    );
  }

  Widget countryAndBirthDate() {
    return GlassActionButton(
      label: Obx(
        () => Text(
          controller.birthday.value.isNotEmpty ? controller.birthday.value : "Your Birthday",
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: 17.sp,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
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
              label: "Male",
              selected: controller.isMale.value == true,
              tint: const Color(0x124A90E2),
              onTap: () {
                controller.isMale.value = true;
              },
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Obx(
            () => _genderChip(
              label: "Female",
              selected: controller.isMale.value == false,
              tint: const Color(0x12B968C7),
              onTap: () {
                controller.isMale.value = false;
              },
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
    return Row(
      children: <Widget>[
        Expanded(
          child: GlassActionButton(
            label: Text(
              "GO BACK",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            onTap: controller.navigateToLogin,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: GlassActionButton(
            label: Text(
              "SIGN UP",
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
          ),
        ),
      ],
    );
  }
}