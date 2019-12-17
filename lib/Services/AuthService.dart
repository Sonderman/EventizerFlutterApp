import 'package:eventizer/Services/BaseAuth.dart';
import 'package:flutter/widgets.dart';

class AuthService extends InheritedWidget {
  AuthService({Key key, this.auth, Widget child})
      : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static AuthService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthService>();
  }
}
