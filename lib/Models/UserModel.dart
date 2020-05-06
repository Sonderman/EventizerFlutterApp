import 'package:flutter/material.dart';

class User {
  final String userID;
  String _name;
  String _surname;
  String _nickname;
  String _email;
  String _telno;
  String _birthday;
  String _city;
  String _gender;
  String _about;
  String _profilePhotoUrl;
  int _numberOfFollowers;
  int _numberOfEvents;
  int _numberOfTrustPoints;

  User({@required this.userID});

  String getUserId() => userID;

  String getUserName() => _name;

  String getUserNickName() => _nickname;

  String getUserAbout() => _about;

  String getUserEmail() => _email;

  String getUserSurname() => _surname;

  String getUserTelno() => _telno;

  String getUserBirthday() => _birthday;

  int getUserFollowNumber() => _numberOfFollowers;

  int getUserEventsNumber() => _numberOfEvents;

  int getUserTrustPointNumber() => _numberOfTrustPoints;

  String getUserProfilePhotoUrl() {
    if (_profilePhotoUrl == null) {
      return "https://farm5.staticflickr.com/4363/36346283311_74018f6e7d_o.png";
    } else
      return _profilePhotoUrl;
  }

  void setUserName(String name) {
    _name = name;
  }

  void setSurname(String surname) {
    _surname = surname;
  }

  void setNickName(String nickname) {
    _nickname = nickname;
  }

  void setEmail(String email) {
    _email = email;
  }

  void setAbout(String about) {
    _about = about;
  }

  void setBirthday(String birthday) {
    _birthday = birthday;
  }

  void setCity(String city) {
    _city = city;
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': _name ?? 'null',
      'Surname': _surname ?? 'null',
      'NickName': _nickname ?? 'null',
      'Email': _email ?? 'null',
      'Birthday': _birthday ?? 'null',
      'Gender': _gender ?? 'null',
      'City': _city ?? 'null',
      'Telno': _telno ?? 'null',
      'ProfilePhotoUrl': _profilePhotoUrl ?? 'null',
      'About': _about ?? 'null',
      'Nof_follower': _numberOfFollowers ?? 0,
      'Nof_events': _numberOfEvents ?? 0,
      'Nof_trustPoint': _numberOfTrustPoints ?? 0,
    };
  }

  void parseMap(Map<String, dynamic> map) {
    _name = map["Name"] ?? "null";
    _surname = map["Surname"] ?? "null";
    _nickname = map["NickName"] ?? "null";
    _email = map["Email"] ?? "null";
    _telno = map["Telno"] ?? "null";
    _city = map["City"] ?? "null";
    _birthday = map["Birthday"] ?? "null";
    _gender = map["Gender"] ?? "null";
    _profilePhotoUrl = map["ProfilePhotoUrl"];
    _about = map['About'] ?? "Henüz Detay Girilmedi.";
    _numberOfFollowers = map['Nof_follower'] ?? 0;
    _numberOfEvents = map['Nof_events'] ?? 0;
    _numberOfTrustPoints = map['Nof_trustPoint'] ?? 0;
  }
}
