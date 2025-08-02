import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class MyLiquidGlass {
  static LiquidGlass standartContainer({required Widget child, Key? key}) => LiquidGlass(
    key: key,
    shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(15)),
    glassContainsChild: false,
    settings: LiquidGlassSettings(
      ambientStrength: 0.5,
      lightAngle: 0.2 * math.pi,
      blur: 2,
      // glassColor: Colors.white24,
    ),
    child: child,
  );
  static LiquidGlass standartButton({required Widget child, Key? key}) => LiquidGlass(
    key: key,
    shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(10)),
    glassContainsChild: false,

    settings: LiquidGlassSettings(
      ambientStrength: 5,
      //lightAngle: 0.5 * math.pi,
      glassColor: Colors.white12,
      lightIntensity: 0.5,
      thickness: 10,
    ),
    child: child,
  );
  static LiquidGlass selectableButton({
    required Widget child,
    Key? key,
    bool? isSelected = false,
    Color? selectedColor,
    Color? unselectedColor,
  }) => LiquidGlass(
    key: key,
    shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(10)),
    glassContainsChild: false,
    settings: LiquidGlassSettings(
      ambientStrength: 1,
      //lightAngle: 0.5 * math.pi,
      glassColor: isSelected == true
          ? selectedColor ?? Colors.white12
          : unselectedColor ?? Colors.white12,
      lightIntensity: 1,
      thickness: 5,
    ),
    child: child,
  );
  static LiquidGlass standartCircle({required Widget child, Key? key}) => LiquidGlass(
    key: key,
    shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(100)),
    glassContainsChild: false,
    settings: LiquidGlassSettings(
      ambientStrength: 1,
      lightAngle: 0.2 * math.pi,
      glassColor: Colors.white12,
      lightIntensity: 0.5,
      thickness: 5,
    ),
    child: child,
  );
  static LiquidGlass standartDialog({required Widget child, Key? key}) => LiquidGlass(
    key: key,
    shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(10)),
    glassContainsChild: false,
    settings: LiquidGlassSettings(
      ambientStrength: 5,
      //lightAngle: 0.5 * math.pi,
      glassColor: Colors.white12,
      lightIntensity: 10,
      thickness: 10,
    ),
    child: child,
  );
}
