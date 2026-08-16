import 'package:eventizer/data/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(color: Colors.white),
        Center(
          child: GlassContainer(
            shape: const LiquidRoundedSuperellipse(borderRadius: 24),
            padding: const EdgeInsets.all(28),
            useOwnLayer: true,
            settings: const LiquidGlassSettings(
              blur: 0,
              thickness: 11,
              glassColor: Color(0x124A90E2),
              lightAngle: 0.75 * 3.141592653589793,
              lightIntensity: 0.98,
              ambientStrength: 0.18,
              saturation: 1.0,
              chromaticAberration: 0.01,
              specularSharpness: GlassSpecularSharpness.medium,
            ),
            child: SpinKitRing(
              color: MyColors.indiagoLoadingSplash,
              size: 50.0,
            ),
          ),
        ),
      ],
    );
  }
}