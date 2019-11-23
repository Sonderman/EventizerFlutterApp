import 'package:eventizer/Models/UserModel.dart';
import 'package:flutter/material.dart';



class UserWorker with ChangeNotifier{
  User _usermodel;
  UserWorker(String userId){
    userInitializer(userId);
  }

void userInitializer(String userId){
  if(userId == null || userId == ""){
    userId = "0000000000000000";
  }
  _usermodel = User(userID: userId);
  notifyListeners();
}

String getUserId(){
  return _usermodel.userID;
}
String getName(){
  return _usermodel.userName;
}
void setName(String name){
  _usermodel.userName= name;
  notifyListeners();
}
}

/*
Provider kullanımı
final  userWorker = Provider.of<UserWorker>(context);
*/