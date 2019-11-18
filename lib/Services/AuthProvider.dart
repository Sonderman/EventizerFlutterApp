import 'package:flutter/material.dart';
import 'BaseAuth.dart';

class AuthProvider extends InheritedWidget{
  AuthProvider({Key key,this.auth, Widget child}) : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    
    return true;
  }
static AuthProvider of(BuildContext context){
  return (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider);
}
}