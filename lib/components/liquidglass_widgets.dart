import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class MyLiquidGlass {
  // ---------------------------------------------------------------------------
  // "Net cam" presets — liquid_glass_catalog projesindeki kClearGlass* değerleri.
  // - blur = 0: buzlu/frosted görünüm yok, arka plan net görünür.
  // - glassColor şeffaf: yüzeye renk boyanmaz, sadece ışık kırılması + rim.
  // - lightAngle: 0.75π (135°, üst-sol) — Apple standardı, tüm yüzeylerde tutarlı.
  // ---------------------------------------------------------------------------

  /// Temel net cam — kartlar, paneller, form alanları.
  static const LiquidGlassSettings standard = LiquidGlassSettings(
    blur: 0,
    thickness: 8,
    glassColor: Color(0x00000000),
    refractiveIndex: 0.82,
    lightAngle: 0.75 * math.pi,
    lightIntensity: 0.9,
    ambientStrength: 0.12,
    saturation: 1.0,
    chromaticAberration: 0.008,
    specularSharpness: GlassSpecularSharpness.medium,
  );

  /// Etkileşimli yüzeyler — biraz daha güçlü rim/refraction.
  static const LiquidGlassSettings interactive = LiquidGlassSettings(
    blur: 0,
    thickness: 10,
    glassColor: Color(0x00000000),
    refractiveIndex: 0.86,
    lightAngle: 0.75 * math.pi,
    lightIntensity: 0.95,
    ambientStrength: 0.16,
    saturation: 1.0,
    chromaticAberration: 0.01,
    specularSharpness: GlassSpecularSharpness.medium,
  );

  /// Kartlar/paneller için — standard ile aynı net görünüm.
  static const LiquidGlassSettings overlay = LiquidGlassSettings(
    blur: 0,
    thickness: 8,
    glassColor: Color(0x00000000),
    refractiveIndex: 0.82,
    lightAngle: 0.75 * math.pi,
    lightIntensity: 0.9,
    ambientStrength: 0.12,
    saturation: 1.0,
    chromaticAberration: 0.008,
    specularSharpness: GlassSpecularSharpness.medium,
  );

  /// Form alanları için — net cam.
  static const LiquidGlassSettings input = LiquidGlassSettings(
    blur: 0,
    thickness: 8,
    glassColor: Color(0x00000000),
    refractiveIndex: 0.82,
    lightAngle: 0.75 * math.pi,
    lightIntensity: 0.9,
    ambientStrength: 0.12,
    saturation: 1.0,
    chromaticAberration: 0.008,
    specularSharpness: GlassSpecularSharpness.medium,
  );

  /// Geniş plaka butonlar: primary'de hafif mavi tint + kalın rim,
  /// secondary'de şeffaf net cam.
  static LiquidGlassSettings button({bool primary = false}) {
    if (primary) {
      return const LiquidGlassSettings(
        blur: 0,
        thickness: 11,
        glassColor: Color(0x124A90E2),
        refractiveIndex: 0.88,
        lightAngle: 0.75 * math.pi,
        lightIntensity: 0.98,
        ambientStrength: 0.18,
        saturation: 1.0,
        chromaticAberration: 0.01,
        specularSharpness: GlassSpecularSharpness.medium,
      );
    }
    return interactive;
  }

  static Widget appShell({required Widget child}) {
    return LiquidGlassLayer(
      settings: MyLiquidGlass.standard,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Buz mavisi zemin — kontrast için orta-koyu tonlar.
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF93AECF), // üst: açık slate blue
                  Color(0xFF6C8FB5), // orta: mavi
                  Color(0xFF3D5A7E), // alt: koyu mavi
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
          ),
          Opacity(opacity: 0.12, child: Image.asset('assets/images/bg-2.png', fit: BoxFit.cover)),
          child,
        ],
      ),
    );
  }

  static Widget section({
    required Widget child,
    Key? key,
    double borderRadius = 16,
    Color glassColor = const Color(0x1FFFFFFF),
    double ambientStrength = 1.5,
    double lightIntensity = 0.7,
    double thickness = 8,
  }) {
    return _panel(key: key, borderRadius: borderRadius, color: glassColor, child: child);
  }

  static Widget standartContainer({required Widget child, Key? key}) =>
      _panel(key: key, borderRadius: 15, color: const Color(0x22FFFFFF), child: child);

  static Widget standartButton({required Widget child, Key? key}) =>
      _panel(key: key, borderRadius: 10, color: const Color(0x26FFFFFF), child: child);

  static Widget selectableButton({
    required Widget child,
    Key? key,
    bool? isSelected = false,
    Color? selectedColor,
    Color? unselectedColor,
  }) => _panel(
    key: key,
    borderRadius: 10,
    color: isSelected == true ? selectedColor ?? const Color(0x33FFFFFF) : unselectedColor ?? const Color(0x18FFFFFF),
    child: child,
  );

  static Widget standartCircle({required Widget child, Key? key}) =>
      _panel(key: key, borderRadius: 100, color: const Color(0x2AFFFFFF), child: child);

  static Widget standartDialog({required Widget child, Key? key}) =>
      _panel(key: key, borderRadius: 10, color: const Color(0x2EFFFFFF), child: child);

  static Widget _panel({required Widget child, Key? key, required double borderRadius, required Color color}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
      ),
      child: child,
    );
  }
}