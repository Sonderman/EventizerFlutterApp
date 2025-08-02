part of 'sign_up_page.dart';

Widget inputField(
  TextEditingController controller,
  String hintText, {
  Widget? suffixIcon,
  bool obscureText = false,
}) => TextFormField(
  controller: controller,
  textAlign: TextAlign.left,
  cursorColor: MyColors.globalTextColor,
  obscureText: obscureText,
  decoration: InputDecoration(
    border: InputBorder.none,
    hintText: hintText,
    suffixIcon: suffixIcon,
    hintStyle: TextStyle(fontFamily: "ZonaLight", color: MyColors.globalTextColor),
    alignLabelWithHint: true,
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.globalTextColor)),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MyColors.globalTextColor)),
  ),
  style: TextStyle(fontSize: 2.5.h, fontFamily: "Zona", color: MyColors.globalTextColor),
);
