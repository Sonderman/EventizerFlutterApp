import 'package:eventizer/app_settings.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/navigation/login_page/login_components.dart';
import 'package:eventizer/navigation/login_page/login_controller.dart';
import 'package:eventizer/navigation/sign_up_page/sign_up_page.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        // Background image with overlay
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // Semi-transparent overlay for better text readability
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black.withOpacity(0.3),
                MyColors.purpleContainer.withOpacity(0.4),
                Colors.black.withOpacity(0.5),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Obx(
            () => Stack(
              children: <Widget>[
                PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  children: <Widget>[
                    // Login page with modern design
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 8.h),
                            _buildModernHeader(),
                            SizedBox(height: 6.h),
                            _buildModernLoginCard(),
                            const Spacer(),
                            _buildModernButtons(),
                            SizedBox(height: 8.h),
                          ],
                        ),
                      ),
                    ),
                    // SignUp page
                    SignUpPage(controller.pageController),
                  ],
                ),
                if (controller.isLoading.value)
                  PageComponents(context).loadingOverlay(backgroundColor: Colors.black26),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Column(
      children: <Widget>[
        // Modern app logo/title area
        MyLiquidGlass.standartContainer(
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Icon(Icons.event_available, size: 12.w, color: Colors.white),
          ),
        ),
        SizedBox(height: 3.h),
        MyLiquidGlass.standartContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppSettings.appName,
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(height: 1.h),
        Obx(
          () => Text(
            controller.isPasswordVisible.value == false ? "Password Reset" : "Welcome Back",
            style: TextStyle(fontFamily: "ZonaLight", fontSize: 15.sp, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildModernLoginCard() {
    return MyLiquidGlass.standartContainer(
      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildModernEmailField(),
            SizedBox(height: 3.h),
            _buildModernPasswordSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildModernEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Email",
          style: TextStyle(
            fontFamily: "Zona",
            fontSize: 13.sp,
            color: MyColors.globalTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.sp),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(
              hintText: "example@email.com",
              hintStyle: TextStyle(
                fontFamily: "ZonaLight",
                color: MyColors.iconColor,
                fontSize: 12.sp,
              ),
              prefixIcon: Icon(Icons.email_outlined, color: MyColors.globalTextColor, size: 5.w),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            ),
            cursorColor: MyColors.globalTextColor,
            style: TextStyle(fontSize: 13.sp, color: MyColors.globalTextColor),
          ),
        ),
        Obx(
          () => Visibility(
            visible: controller.isShowLogin.value,
            child: Container(
              margin: EdgeInsets.only(top: 2.h),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: controller.rememberPassword,
                child: MyLiquidGlass.standartButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: MyColors.innerContainerColor,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: 12.sp,
                        color: MyColors.globalTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernPasswordSection() {
    return Obx(
      () => Visibility(
        visible: controller.isPasswordVisible.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Password",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 13.sp,
                color: MyColors.whiteThemeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.sp),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: PasswordField(controller: controller),
            ),
            SizedBox(height: 2.h),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: controller.forgetPassword,
                child: MyLiquidGlass.standartButton(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: MyColors.innerContainerColor,
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: 12.sp,
                        color: MyColors.globalTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButtons() {
    return Column(
      children: <Widget>[
        // Main action button
        MyLiquidGlass.standartButton(
          child: SizedBox(
            height: 7.h,
            child: InkWell(
              onTap: controller.handleMainAction,
              child: Center(
                child: Obx(
                  () => Text(
                    controller.sendPasswordMailText.value,
                    style: TextStyle(
                      fontFamily: "Zona",
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        // Secondary button
        MyLiquidGlass.standartButton(
          child: SizedBox(
            width: double.infinity,
            height: 7.h,
            child: InkWell(
              onTap: controller.navigateToSignUp,
              child: Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(
                    fontFamily: "Zona",
                    fontSize: 16.sp,
                    color: MyColors.whiteThemeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
