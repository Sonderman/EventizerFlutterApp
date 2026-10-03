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
            // Sol üstte cyan glow küresi — yavaş "nefes" animasyonlu
            _BreathingGlow(
              top: -80,
              left: -100,
              size: 420,
              color: const Color(0xFF1BC8D9),
              baseOpacity: 0.30,
              duration: const Duration(seconds: 6),
            ),
            // Sağ altta mor glow küresi — ters fazda nefes alır
            _BreathingGlow(
              bottom: -100,
              right: -80,
              size: 460,
              color: const Color(0xFF8358D8),
              baseOpacity: 0.22,
              duration: const Duration(seconds: 7),
              reverse: true,
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
                                // Orta blok kaydırılabilir — klavye açıldığında
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
        Text(
          "Tekrar Hoş Geldin",
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
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Form: net cam alanlar + hata + küçük aksiyonlar
  // ---------------------------------------------------------------------------
  Widget _buildLoginForm() {
    return AutofillGroup(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GlassInputField(
            controller: controller.emailController,
            hint: 'ornek@mail.com',
            label: 'E-posta',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onSubmitted: (_) => FocusScope.of(Get.context!).nextFocus(),
          ),
          SizedBox(height: 2.2.h),
          GlassPasswordInput(
            controller: controller.passwordController,
            hint: '••••••••',
            label: 'Şifre',
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => controller.loginButton(),
          ),
          // Validation / error message — gerçek hata metni controller'dan gelir
          Obx(
            () => controller.errorText.value.isEmpty
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(top: 1.2.h),
                    child: Text(
                      controller.errorText.value,
                      style: TextStyle(
                        fontFamily: "Zona",
                        fontSize: 12.sp,
                        color: Colors.redAccent,
                        shadows: const [Shadow(color: Color(0x8A000000), blurRadius: 6, offset: Offset(0, 1))],
                      ),
                    ),
                  ),
          ),
          SizedBox(height: 1.h),
          Align(
            alignment: Alignment.centerRight,
            child: _buildSmallAction(label: "Şifremi Unuttum?", onTap: controller.goToForgetPassword),
          ),
        ],
      ),
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
        Obx(
          () => GlassActionButton(
            label: Text(
              "Giriş Yap",
              style: TextStyle(
                fontFamily: "Zona",
                fontSize: 17.sp,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            onTap: controller.loginButton,
            primary: true,
            enabled: !controller.isLoading.value,
          ),
        ),
        SizedBox(height: 2.5.h),
        GlassActionButton(
          label: Text(
            "Hesap Oluştur",
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

/// Arka plan glow küresi — yavaşça büyüyüp küçülerek "nefes alır".
/// Refraction'ı canlı tutar; statik kürelerin verdiği donukluk olmaz.
class _BreathingGlow extends StatefulWidget {
  const _BreathingGlow({
    this.top,
    this.left,
    this.bottom,
    this.right,
    required this.size,
    required this.color,
    required this.baseOpacity,
    this.duration = const Duration(seconds: 6),
    this.reverse = false,
  });

  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  final double size;
  final Color color;
  final double baseOpacity;
  final Duration duration;
  final bool reverse;

  @override
  State<_BreathingGlow> createState() => _BreathingGlowState();
}

class _BreathingGlowState extends State<_BreathingGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  )..repeat(reverse: true);
  late final Animation<double> _t = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutSine,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.top,
      left: widget.left,
      bottom: widget.bottom,
      right: widget.right,
      // Nefes hareketi yalnızca bu katmanı yeniden boyar — cam shader'ı
      // her karede tüm arka planı yakaladığı için küreler küçük olsun.
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _t,
          builder: (context, child) {
            // reverse: true ise faz 180° kayar (küreler zıt nefes alır)
            final t = widget.reverse ? (1.0 - _t.value) : _t.value;
            final scale = 1.0 + 0.06 * t;
            final opacity = widget.baseOpacity + 0.08 * (t - 0.5);
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity.clamp(0.0, 0.6),
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        widget.color.withValues(alpha: opacity.clamp(0.0, 0.6)),
                        widget.color.withValues(alpha: opacity.clamp(0.0, 0.6) * 0.25),
                        const Color(0x00000000),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}