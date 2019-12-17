import 'package:eventizer/Services/BaseAuth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({Key key, this.auth, Widget child})
      : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static AuthProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    // return (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider);
  }
}
