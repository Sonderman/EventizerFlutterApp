import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  Widget loadingOverlay(
      {Color backgroundColor = Colors.transparent,
      Color spinColor = Colors.blue,
      double spinSize = 75}) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: SpinKitRing(size: spinSize, color: spinColor));
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
