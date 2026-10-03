import 'package:eventizer/components/glass_action_button.dart';
import 'package:eventizer/components/glass_inputs.dart';
import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:eventizer/locator.dart';
import 'package:eventizer/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:sizer/sizer.dart';

/// Şifre sıfırlama sayfası — login ekranındaki gömülü reset modunun yerini
/// alır. Net cam tasarım + gerçek Firebase şifre sıfırlama maili.
class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;
  RxString errorText = RxString('');
  RxString successText = RxString('');

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  /// Gerçek Firebase şifre sıfırlama maili gönderir.
  Future<void> sendResetEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      errorText.value = 'E-posta adresinizi girin';
      successText.value = '';
      return;
    }
    errorText.value = '';
    successText.value = '';

    isLoading.value = true;
    try {
      final auth = locator<AuthService>();
      await auth.sendPasswordResetEmail(email);
      successText.value = 'Şifre sıfırlama maili gönderildi — gelen kutunuzu kontrol edin';
    } catch (e) {
      errorText.value = 'Mail gönderilemedi: $e';
    } finally {
      isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0C1220), Color(0xFF16243A), Color(0xFF253B59)],
          ),
        ),
        child: Stack(
          children: [
            // Sol üstte cyan glow küresi
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
                      const Color(0xFF1BC8D9).withValues(alpha: 0.25),
                      const Color(0xFF1BC8D9).withValues(alpha: 0.06),
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
                      const Color(0xFF8358D8).withValues(alpha: 0.20),
                      const Color(0xFF3B4FA4).withValues(alpha: 0.06),
                      const Color(0x00000000),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 4.h),
                    // Geri butonu — net cam
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GlassContainer(
                        shape: const LiquidOval(),
                        padding: EdgeInsets.all(3.w),
                        settings: MyLiquidGlass.interactive,
                        useOwnLayer: true,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          behavior: HitTestBehavior.opaque,
                          child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                        ),
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // Başlık kartı
                    GlassCard(
                      shape: const LiquidRoundedSuperellipse(borderRadius: 22),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.6.h),
                      settings: MyLiquidGlass.overlay,
                      useOwnLayer: true,
                      child: Text(
                        "Şifremi Sıfırla",
                        style: TextStyle(
                          fontFamily: "Zona",
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.2.h),
                    Text(
                      "E-posta adresinize sıfırlama bağlantısı göndereceğiz.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        shadows: const [
                          Shadow(color: Color(0x8A000000), blurRadius: 8, offset: Offset(0, 2)),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
                    // E-posta alanı
                    GlassInputField(
                      controller: emailController,
                      hint: 'ornek@mail.com',
                      label: 'E-posta',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => sendResetEmail(),
                    ),
                    // Hata mesajı
                    Obx(
                      () => errorText.value.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(top: 1.2.h),
                              child: Text(
                                errorText.value,
                                style: TextStyle(
                                  fontFamily: "Zona",
                                  fontSize: 12.sp,
                                  color: Colors.redAccent,
                                  shadows: const [
                                    Shadow(color: Color(0x8A000000), blurRadius: 6, offset: Offset(0, 1)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    // Başarı mesajı
                    Obx(
                      () => successText.value.isEmpty
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: EdgeInsets.only(top: 1.2.h),
                              child: Text(
                                successText.value,
                                style: TextStyle(
                                  fontFamily: "Zona",
                                  fontSize: 12.sp,
                                  color: const Color(0xFF4CD97B),
                                  shadows: const [
                                    Shadow(color: Color(0x8A000000), blurRadius: 6, offset: Offset(0, 1)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    const Spacer(),
                    // Gönder butonu
                    Obx(
                      () => GlassActionButton(
                        label: Text(
                          isLoading.value ? "Gönderiliyor..." : "Mail Gönder",
                          style: TextStyle(
                            fontFamily: "Zona",
                            fontSize: 17.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                          ),
                        ),
                        onTap: sendResetEmail,
                        primary: true,
                        enabled: !isLoading.value,
                      ),
                    ),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}