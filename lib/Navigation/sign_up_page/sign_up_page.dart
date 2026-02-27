import 'package:eventizer/Tools/loading.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/data/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../components/custom_scroll.dart';
import 'sign_up_controller.dart';
part './components.dart';

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
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: MyLiquidGlass.standartContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ScrollConfiguration(
                        behavior: NoScrollEffectBehavior(),
                        child: SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              addPhoto(context),
                              SizedBox(height: 1.h),
                              nameSurname(),
                              SizedBox(height: 1.h),
                              emailAndPasswordFields(),
                              SizedBox(height: 1.h),
                              telephoneNumber(),
                              SizedBox(height: 2.h),
                              countryAndBirthDate(),
                              SizedBox(height: 2.h),
                              selectGender(),
                              SizedBox(height: 2.h),
                              signUpButton(),
                              SizedBox(height: 2.h),
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

  Widget addPhoto(BuildContext context) {
    return GestureDetector(
      onTap: controller.showImagePickerDialog,
      child: MyLiquidGlass.standartCircle(
        child: SizedBox(
          width: 30.w,
          height: 30.w,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: controller.profileImage.value == null
                ? Image.asset('assets/images/add-user.png', height: 5.h)
                : ClipOval(
                    child: Image.memory(
                      controller.profileImage.value!,
                      width: 30.w,
                      height: 30.w,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget nameSurname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(height: 8.h, width: 40.w, child: inputField(controller.nameController, "Name*")),
        SizedBox(
          height: 8.h,
          width: 40.w,
          child: inputField(controller.surnameController, "Surname*"),
        ),
      ],
    );
  }

  Widget emailAndPasswordFields() {
    return Column(
      children: <Widget>[
        inputField(controller.emailController, "Email*"),
        SizedBox(height: 3.h),
        inputField(
          controller.passwordController,
          "Password*",
          obscureText: controller.showPassword.value,
          suffixIcon: TextButton(
            child: Icon(
              controller.showPassword.value ? Icons.visibility : Icons.visibility_off,
              color: MyColors.globalTextColor,
            ),
            onPressed: () {
              controller.showPassword.value = !controller.showPassword.value;
            },
          ),
        ),
        SizedBox(height: 3.h),
        inputField(
          controller.passwordConfirmController,
          "Password Confirm*",
          obscureText: controller.showPassword.value,
          suffixIcon: TextButton(
            child: Icon(
              controller.showPassword.value ? Icons.visibility : Icons.visibility_off,
              color: MyColors.globalTextColor,
            ),
            onPressed: () {
              controller.showPassword.value = !controller.showPassword.value;
            },
          ),
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget telephoneNumber() {
    return TextFormField(
      controller: controller.phoneController,
      textAlign: TextAlign.left,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 10,
      cursorColor: MyColors.globalTextColor,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Phone Number",
        hintStyle: TextStyle(fontFamily: "ZonaLight", color: MyColors.globalTextColor),
        counterStyle: TextStyle(fontFamily: "Zona", color: MyColors.globalTextColor),
        alignLabelWithHint: true,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.globalTextColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: MyColors.globalTextColor),
        ),
      ),
      style: TextStyle(fontSize: 2.5.h, fontFamily: "Zona", color: MyColors.globalTextColor),
    );
  }

  Widget countryAndBirthDate() {
    return InkWell(
      onTap: controller.selectBirthday,
      child: MyLiquidGlass.standartButton(
        child: SizedBox(
          width: 70.w,
          height: 8.h,
          child: Center(
            child: Text(
              controller.birthday.value.isNotEmpty ? controller.birthday.value : "Your Birthday",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 16.sp,
                color: MyColors.globalTextColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectGender() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        InkWell(
          onTap: () {
            controller.isMale.value = true;
          },
          child: MyLiquidGlass.selectableButton(
            isSelected: controller.isMale.value,
            selectedColor: Colors.blue,
            child: SizedBox(
              width: 43.w,
              height: 5.h,
              child: Center(
                child: Text(
                  "Male",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 2.h,
                    color: MyColors.globalTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            controller.isMale.value = false;
          },
          child: MyLiquidGlass.selectableButton(
            isSelected: controller.isMale.value == false,
            selectedColor: Colors.pink,
            child: SizedBox(
              width: 43.w,
              height: 5.h,
              child: Center(
                child: Text(
                  "Female",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 2.h,
                    color: MyColors.globalTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget signUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        MyLiquidGlass.standartButton(
          child: InkWell(
            onTap: controller.navigateToLogin,
            child: SizedBox(
              width: 42.w,
              height: 8.h,
              child: Center(
                child: Text(
                  "GO BACK",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 16.sp,
                    color: MyColors.globalTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: controller.signUp,
          child: MyLiquidGlass.standartButton(
            child: SizedBox(
              width: 42.w,
              height: 8.h,
              child: Center(
                child: Text(
                  "SIGN UP",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 16.sp,
                    color: MyColors.globalTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color menColor() {
    return MyColors.blueContainer;
  }

  MaterialAccentColor womenColor() {
    return Colors.pinkAccent;
  }
}
