import 'package:eventizer/assets/Colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class PageComponents {
  Widget loadingOverlay(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.transparent,
        child: SpinKitRing(size: 75, color: MyColors().blueThemeColor));
  }
}
