// Separate widget for password field to handle its own state
import 'package:eventizer/data/themes.dart';
import 'package:eventizer/navigation/login_page/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PasswordField extends StatefulWidget {
  final LoginController controller;

  const PasswordField({super.key, required this.controller});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            controller: widget.controller.passwordController,
            obscureText: showPassword,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              errorText: widget.controller.errorText.value.isEmpty
                  ? null
                  : widget.controller.errorText.value,
              errorStyle: TextStyle(fontSize: 8.sp, fontFamily: "Zona", color: Colors.red),
              border: InputBorder.none,
              hintText: "Password",
              hintStyle: TextStyle(fontFamily: "ZonaLight", color: MyColors.globalTextColor),
              contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              suffixIcon: TextButton(
                child: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: MyColors.whiteThemeColor,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
            cursorColor: MyColors.globalTextColor,
            style: TextStyle(fontSize: 13.sp, color: MyColors.globalTextColor),
          ),
        ),
      ],
    );
  }
}
