import 'package:eventizer/app_settings.dart';
import 'package:eventizer/components/glass_action_button.dart';
import 'package:eventizer/components/glass_inputs.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/navigation/login_page/login_controller.dart';
import 'package:eventizer/navigation/sign_up_page/sign_up_page.dart';
import 'package:eventizer/tools/page_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:sizer/sizer.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      // Klavye açıldığında gövde küçülür; orta blok kaydırılabilir olduğu
      // için içerik ekrana sığmadığında RenderFlex overflow yaşanmaz.
      resizeToAvoidBottomInset: true,
      body: Container(
        // Koyu lacivert zemin (kDarkBackdrop) — resmin altında
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1220), Color(0xFF16243A), Color(0xFF253B59)],
          ),
        ),
        child: Stack(
          children: [
            // Arka plan resmi — ekrana tam oturur (fit: cover)
            Positioned.fill(
              child: Image.asset('assets/images/login_background.jpg', fit: BoxFit.cover, alignment: Alignment.center),
            ),
            // Sol üstte cyan glow küresi (katalogdaki orb)
            Positioned(
              top: -80,
              left: -100,
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF1BC8D9).withValues(alpha: 0.30),
                      const Color(0xFF1BC8D9).withValues(alpha: 0.08),
                      const Color(0x00000000),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Sağ altta mor glow küresi
            Positioned(
              bottom: -100,
              right: -80,
              child: Container(
                width: 460,
                height: 460,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF8358D8).withValues(alpha: 0.22),
                      const Color(0xFF3B4FA4).withValues(alpha: 0.08),
                      const Color(0x00000000),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Hafif karartma — metin ve cam yüzeylerin okunurluğu için
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black.withValues(alpha: 0.15), Colors.black.withValues(alpha: 0.30)],
                ),
              ),
            ),
            Obx(
              () => Stack(
                children: <Widget>[
                  PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.pageController,
                    children: <Widget>[
                      SafeArea(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w),
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                // Orta blok kaydırılabilir — "Password Reset"
                                // modundaki ek satırlar ve klavye açıldığında
                                // Column taşması (RenderFlex overflow) olmaz.
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 6.h),
                                      _buildHeader(),
                                      SizedBox(height: 5.h),
                                      _buildLoginForm(),
                                    ],
                                  ),
                                ),
                              ),
                              _buildButtons(),
                              SizedBox(height: 3.h),
                            ],
                          ),
                        ),
                      ),
                      SignUpPage(controller.pageController),
                    ],
                  ),
                  if (controller.isLoading.value)
                    PageComponents(context).loadingOverlay(backgroundColor: Colors.black26),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header: logo + uygulama adı — net cam kartlar
  // ---------------------------------------------------------------------------
  Widget _buildHeader() {
    return Column(
      children: <Widget>[
        GlassCard(
          shape: const LiquidRoundedSuperellipse(borderRadius: 24),
          padding: EdgeInsets.all(5.w),
          settings: MyLiquidGlass.overlay,
          useOwnLayer: true,
          child: Image.asset('assets/eventizer_logo-nobg.png', width: 25.w, height: 25.w),
        ),
        SizedBox(height: 2.5.h),
        GlassCard(
          shape: const LiquidRoundedSuperellipse(borderRadius: 22),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.6.h),
          settings: MyLiquidGlass.overlay,
          useOwnLayer: true,
          child: Text(
            AppSettings.appName,
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        SizedBox(height: 1.2.h),
        Obx(
          () => Text(
            controller.isPasswordVisible.value == false ? "Password Reset" : "Welcome Back",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
              color: Colors.white,
              // Açık zeminli arka plan görselinde okunurluk için güçlü gölge
              shadows: const [Shadow(color: Color(0x8A000000), blurRadius: 10, offset: Offset(0, 2))],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Form: net cam alanlar + hata + küçük aksiyonlar
  // ---------------------------------------------------------------------------
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GlassInputField(controller: controller.emailController, hint: 'example@email.com', label: 'Email'),
        SizedBox(height: 2.2.h),
        GlassPasswordInput(controller: controller.passwordController, hint: 'Password', label: 'Password'),
        // Validation / error message
        Obx(
          () => controller.errorText.value.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.only(top: 1.2.h),
                  child: Text(
                    controller.errorText.value,
                    style: TextStyle(fontFamily: "Zona", fontSize: 12.sp, color: Colors.redAccent),
                  ),
                ),
        ),
        SizedBox(height: 1.h),
        // İki chip asla aynı anda gösterilmez — reset modunda "Forgot Password?"
        // gizlenir, yerine "Already have an account?" gelir. Böylece alttaki
        // butonun arkasında kalan chip sorunu oluşmaz.
        Obx(
          () => Visibility(
            visible: !controller.isShowLogin.value,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildSmallAction(label: "Forgot Password?", onTap: controller.forgetPassword),
            ),
          ),
        ),
        SizedBox(height: 1.5.h),
        Obx(
          () => Visibility(
            visible: controller.isShowLogin.value,
            child: Align(
              alignment: Alignment.centerRight,
              child: _buildSmallAction(label: "Already have an account?", onTap: controller.rememberPassword),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Küçük cam aksiyon chip'i
  // ---------------------------------------------------------------------------
  Widget _buildSmallAction({required String label, required VoidCallback onTap}) {
    return GlassChip(
      label: label,
      onTap: onTap,
      settings: MyLiquidGlass.interactive,
      useOwnLayer: true,
      labelStyle: TextStyle(fontFamily: "Zona", fontSize: 13.sp, color: Colors.white, fontWeight: FontWeight.w500),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.2.h),
    );
  }

  // ---------------------------------------------------------------------------
  // Ana aksiyon butonları
  // ---------------------------------------------------------------------------
  Widget _buildButtons() {
    return Column(
      children: <Widget>[
        GlassActionButton(
          label: Obx(
            () => Text(
              controller.sendPasswordMailText.value,
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          onTap: controller.handleMainAction,
          primary: true,
        ),
        SizedBox(height: 2.5.h),
        GlassActionButton(
          label: Text(
            "Create Account",
            style: TextStyle(
              fontFamily: "Zona",
              fontSize: 17.sp,
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          onTap: controller.navigateToSignUp,
        ),
      ],
    );
  }
}
