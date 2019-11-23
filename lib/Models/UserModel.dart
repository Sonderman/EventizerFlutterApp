import 'package:flutter/material.dart';

class User{
  final String userID;
  String userName;
  String userSurname;
  String userEmail;
  
  User({@required this.userID});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'userName': userName ?? 'null',
      'userSurname': userSurname ?? 'null',
      'userEmail': userEmail ?? 'null'
    };
  }
 
}
