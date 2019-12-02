import 'package:flutter/material.dart';

class User {
  final String userID;
  String name;
  String surname;
  String email;
  String telno;
  String birthday;
  String city;
  String gender;
  String profilePhotoUrl;

  User({@required this.userID});

  Map<String, dynamic> toMap() {
    return {
      'Name': name ?? 'null',
      'Surname': surname ?? 'null',
      'Email': email ?? 'null',
      'Birthday': birthday ?? 'null',
      'Gender': gender ?? 'null',
      'City': city ?? 'null',
      'Telno': telno ?? 'null',
      'ProfilePhotoUrl': profilePhotoUrl ?? 'null'
    };
  }
}
