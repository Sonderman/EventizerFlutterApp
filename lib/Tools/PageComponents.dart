import 'package:eventizer/assets/Colors.dart';
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

  Widget loadingCustomOverlay(double size, Color color) {
    return Container(
      height: size,
      width: size,
      child: SpinKitRing(size: 75, color: color),
    );
  }

  Widget loadingOverlay(Color backgroundColor) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: backgroundColor,
        child: SpinKitRing(size: 75, color: MyColors().blueThemeColor));
  }

  Widget underConstruction() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        child: Container(
          height: heightSize(70),
          child: Image.asset("assets/images/underConstruction.jpg"),
        ),
      ),
    );
  }
}
