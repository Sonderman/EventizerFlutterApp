import 'package:eventizer/components/liquidglass_widgets.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:sizer/sizer.dart';

/// Cam yüzeyli inkwell buton — GlassContainer'a sarılı etkileşimli alan.
class GlassActionButton extends StatelessWidget {
  const GlassActionButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = false,
    this.height,
    this.width,
    this.borderRadius = 20,
    this.enabled = true,
  });

  final Widget label;
  final VoidCallback onTap;
  final bool primary;
  final double? height;
  final double? width;
  final double borderRadius;

  /// false iken dokunma pasif ve yüzey %45 saydam — yükleme sırasında
  /// çift dokunuşu önlemek için.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Devre dışı durumda cam yüzey soluklaşır, dokunma yutulur.
    final LiquidGlassSettings effective = enabled
        ? MyLiquidGlass.button(primary: primary)
        : LiquidGlassSettings(
            blur: MyLiquidGlass.button(primary: primary).blur,
            thickness: MyLiquidGlass.button(primary: primary).thickness,
            glassColor: Colors.white.withValues(alpha: 0.06),
            lightAngle: 0.75 * 3.141592653589793,
            lightIntensity: 0.5,
            ambientStrength: 0.12,
            saturation: 1.0,
            chromaticAberration: 0.01,
            specularSharpness: GlassSpecularSharpness.medium,
          );

    return GlassContainer(
      width: width ?? double.infinity,
      height: height ?? 7.5.h,
      shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
      useOwnLayer: true,
      settings: effective,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.55,
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          behavior: HitTestBehavior.opaque,
          child: Center(child: label),
        ),
      ),
    );
  }
}