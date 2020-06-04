import 'package:flutter/material.dart';

class User {
  final String userID;
  String _name;
  String _surname;
  String _nickname;
  String _email;
  int _telNo;
  String _birthday;
  String _country;
  String _city;
  String _gender;
  String _about;
  String _profilePhotoUrl;
  int _numberOfFollowers;
  int _numberOfFollowings;
  int _numberOfEvents;
  int _numberOfTrustPoints;

  User({@required this.userID});

  //ANCHOR Getters
  String getUserId() => userID;

  String getUserName() => _name;

  String getUserNickName() => _nickname;

  String getUserAbout() => _about;

  String getUserEmail() => _email;

  String getUserSurname() => _surname;

  String getUserGender() => _gender;

  int getUserTelNo() => _telNo;

  String getUserCountry() => _country;

  String getUserCity() => _city;

  String getUserBirthday() => _birthday;

  int getUserFollowNumber() => _numberOfFollowers;

  int getUserFollowingNumber() => _numberOfFollowings;

  int getUserEventsNumber() => _numberOfEvents;

  int getUserTrustPointNumber() => _numberOfTrustPoints;

  String getUserProfilePhotoUrl() {
    if (_profilePhotoUrl == null) {
      return "https://farm5.staticflickr.com/4363/36346283311_74018f6e7d_o.png";
    } else
      return _profilePhotoUrl;
  }

  //ANCHOR Setters
  void setUserName(String name) {
    _name = name;
  }

  void setUserSurname(String surname) {
    _surname = surname;
  }

  void setUserNickName(String nickname) {
    _nickname = nickname;
  }

  void setUserEmail(String email) {
    _email = email;
  }

  void setUserCountry(String country) {
    _country = country;
  }

  void setUserAbout(String about) {
    _about = about;
  }

  void setUserGender(String gender) {
    _gender = gender;
  }

  void setUserBirthday(String birthday) {
    _birthday = birthday;
  }

  void setUserCity(String city) {
    _city = city;
  }

  void setUserTelNo(int telNo) {
    _telNo = telNo;
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': _name ?? 'null',
      'Surname': _surname ?? 'null',
      'NickName': _nickname ?? 'null',
      'Email': _email ?? 'null',
      'BirthDay': _birthday ?? 'null',
      'Gender': _gender ?? 'null',
      'Country': _country ?? 'null',
      'City': _city ?? 'null',
      'ProfilePhotoUrl': _profilePhotoUrl ?? 'null',
      'About': _about ?? 'null',
      'PhoneNumber': _telNo ?? 0,
      'Nof_follower': _numberOfFollowers ?? 0,
      'Nof_following': _numberOfFollowings ?? 0,
      'Nof_events': _numberOfEvents ?? 0,
      'Nof_trustPoint': _numberOfTrustPoints ?? 0,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    _name = map["Name"] ?? "null";
    _surname = map["Surname"] ?? "null";
    _nickname = map["NickName"] ?? "null";
    _email = map["Email"] ?? "null";
    _country = map["Country"] ?? "null";
    _city = map["City"] ?? "null";
    _birthday = map["BirthDay"] ?? "null";
    _gender = map["Gender"] ?? "null";
    _profilePhotoUrl = map["ProfilePhotoUrl"];
    _about = map['About'] ?? "Henüz Detay Girilmedi.";
    _telNo = map["PhoneNumber"] ?? 0;
    _numberOfFollowers = map['Nof_follower'] ?? 0;
    _numberOfFollowings = map['Nof_following'] ?? 0;
    _numberOfEvents = map['Nof_events'] ?? 0;
    _numberOfTrustPoints = map['Nof_trustPoint'] ?? 0;
  }
}
