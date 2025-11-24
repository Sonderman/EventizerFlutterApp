import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class MyLiquidGlass {
  static LiquidGlassLayer standartContainer({required Widget child, Key? key}) => LiquidGlassLayer(
    settings: LiquidGlassSettings(
      ambientStrength: 0.5,
      lightAngle: 0.2 * math.pi,
      blur: 2,
      // glassColor: Colors.white24,
    ),
    child: LiquidGlass(
      key: key,
      shape: LiquidRoundedSuperellipse(borderRadius: 15),
      glassContainsChild: false,
      child: child,
    ),
  );
  static LiquidGlassLayer standartButton({required Widget child, Key? key}) => LiquidGlassLayer(
    settings: LiquidGlassSettings(
      ambientStrength: 5,
      //lightAngle: 0.5 * math.pi,
      glassColor: Colors.white12,
      lightIntensity: 0.5,
      thickness: 10,
    ),
    child: LiquidGlass(
      key: key,
      shape: LiquidRoundedSuperellipse(borderRadius: 10),
      glassContainsChild: false,
      child: child,
    ),
  );
  static LiquidGlassLayer selectableButton({
    required Widget child,
    Key? key,
    bool? isSelected = false,
    Color? selectedColor,
    Color? unselectedColor,
  }) => LiquidGlassLayer(
    settings: LiquidGlassSettings(
      ambientStrength: 1,
      //lightAngle: 0.5 * math.pi,
      glassColor: isSelected == true
          ? selectedColor ?? Colors.white12
          : unselectedColor ?? Colors.white12,
      lightIntensity: 1,
      thickness: 5,
    ),
    child: LiquidGlass(
      key: key,
      shape: LiquidRoundedSuperellipse(borderRadius: 10),
      glassContainsChild: false,

      child: child,
    ),
  );
  static LiquidGlassLayer standartCircle({required Widget child, Key? key}) => LiquidGlassLayer(
    settings: LiquidGlassSettings(
      ambientStrength: 1,
      lightAngle: 0.2 * math.pi,
      glassColor: Colors.white12,
      lightIntensity: 0.5,
      thickness: 5,
    ),
    child: LiquidGlass(
      key: key,
      shape: LiquidRoundedSuperellipse(borderRadius: 100),
      glassContainsChild: false,

      child: child,
    ),
  );
  static LiquidGlassLayer standartDialog({required Widget child, Key? key}) => LiquidGlassLayer(
    settings: LiquidGlassSettings(
      ambientStrength: 5,
      //lightAngle: 0.5 * math.pi,
      glassColor: Colors.white12,
      lightIntensity: 10,
      thickness: 10,
    ),
    child: LiquidGlass(
      key: key,
      shape: LiquidRoundedSuperellipse(borderRadius: 10),
      glassContainsChild: false,

      child: child,
    ),
  );
}
