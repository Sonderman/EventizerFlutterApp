import 'package:eventizer/Models/UserModel.dart';
import 'package:flutter/widgets.dart';

class UserProvider extends InheritedWidget{
  UserProvider({Key key,this.user, Widget child}): super(key: key, child: child);
  final User user;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
  static UserProvider of(BuildContext context){
  return (context.inheritFromWidgetOfExactType(UserProvider) as UserProvider);
}
}