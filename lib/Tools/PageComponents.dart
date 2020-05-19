import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PageComponents {
  double heightSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.height * value;
  }

  double widthSize(BuildContext context, double value) {
    value /= 100;
    return MediaQuery.of(context).size.width * value;
  }

  Widget loadingSmallOverlay(double size) {
    return Container(
      height: size,
      width: size,
      child: SpinKitRing(size: 75, color: MyColors().blueThemeColor),
    );
  }

  Widget loadingOverlay(BuildContext context, Color backgroundColor) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: SpinKitRing(size: 75, color: MyColors().blueThemeColor));
  }

  Widget underConstruction(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        child: Container(
          height: heightSize(context, 70),
          child: Image.asset("assets/images/underConstruction.jpg"),
        ),
      ),
    );
  }
}
