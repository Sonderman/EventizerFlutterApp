import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class PageComponents {
  final BuildContext context;
  PageComponents(this.context);

  double heightSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget loadingCustomOverlay(
      {double spinSize = 50,
      double containerWidth = 50,
      double containerHeight = 50,
      Color spinColor = Colors.blue,
      Color containerColor = Colors.transparent}) {
    return Container(
      color: containerColor,
      height: containerHeight,
      width: containerWidth,
      child: SpinKitRing(size: spinSize, color: spinColor),
    );
  }

  Widget loadingOverlay({
    Color backgroundColor = Colors.transparent,
    Color spinColor = Colors.white,
    double spinSize = 60,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Hafif karartma
        Container(color: backgroundColor),
        // Hafif blur + koyu overlay
        Positioned.fill(
          child: ColoredBox(color: Colors.black.withValues(alpha: 0.28)),
        ),
        // Cam spinner kutusu
        Center(
          child: GlassContainer(
            shape: const LiquidRoundedSuperellipse(borderRadius: 24),
            padding: const EdgeInsets.all(24),
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
            child: SpinKitRing(size: spinSize, color: spinColor),
          ),
        ),
      ],
    );
  }

  Widget underConstruction() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        child: SizedBox(
          height: heightSize(70),
          child: Image.asset("assets/images/underConstruction.jpg"),
        ),
      ),
    );
  }
}