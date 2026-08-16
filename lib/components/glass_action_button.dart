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
  });

  final Widget label;
  final VoidCallback onTap;
  final bool primary;
  final double? height;
  final double? width;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: width ?? double.infinity,
      height: height ?? 7.5.h,
      shape: LiquidRoundedSuperellipse(borderRadius: borderRadius),
      useOwnLayer: true,
      settings: MyLiquidGlass.button(primary: primary),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(child: label),
      ),
    );
  }
}