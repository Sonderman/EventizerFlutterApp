import 'dart:io';

import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Services/Firebase.dart';
import 'package:flutter/material.dart';

class UserWorker with ChangeNotifier {
  User _usermodel;
  final DatabaseWorks firebaseDatabaseWorks;
  final StorageWorks firebaseStorageWorks;

  UserWorker(
      String userId, this.firebaseDatabaseWorks, this.firebaseStorageWorks) {
    userInitializer(userId);
  }

  void userInitializer(String userId) {
    if (userId == null || userId == "") {
      userId = "0000000000000000";
      _usermodel = User(userID: userId);
    } else {
      _usermodel = User(userID: userId);

      firebaseDatabaseWorks.getUserProfilePhotoUrl(userId).then((value) {
        _usermodel.profilePhotoUrl = value;
        //print("ProfileImageUrl :" + value);
      });
      userModelUpdater(userId);
    }
  }

  Future<Map<String, dynamic>> getTempUserMap(String userID) async {
    return await firebaseDatabaseWorks.getUserInfoMap(userID).then((map) {
      print("Temp user name:" + map["Name"]);
      return map;
    });
  }

  Future<Map<String, dynamic>> findUserbyID(String userID) {
    return firebaseDatabaseWorks.findUserbyID(userID);
  }

  Future<bool> updateProfilePhoto(File image) async {
    if (image == null) return false;
    return await firebaseStorageWorks.updateProfilePhoto(
            _usermodel.userID, image) ??
        false;
  }

  void userModelUpdater(String userId) {
    Map<String, dynamic> userMap;
    firebaseDatabaseWorks.getUserInfoMap(userId).then((map) {
      userMap = map;
    }).whenComplete(() {
      try {
        _usermodel.name = userMap["Name"];
        _usermodel.surname = userMap["Surname"];
        _usermodel.email = userMap["Email"];
        _usermodel.telno = userMap["Telno"] ?? "null";
        _usermodel.city = userMap["City"];
        _usermodel.birthday = userMap["Birthday"];
        _usermodel.gender = userMap["Gender"];
        _usermodel.profilePhotoUrl = userMap["ProfilePhotoUrl"];
      } catch (e) {
        print(e);
      }
    });
  }

  Map<String, dynamic> getUserMap() {
    return _usermodel.toMap();
  }

  String getUserProfilePhotoUrl() {
    if (_usermodel.profilePhotoUrl == null) {
      return "https://farm5.staticflickr.com/4363/36346283311_74018f6e7d_o.png";
    } else
      return _usermodel.profilePhotoUrl;
  }

  String getUserId() {
    return _usermodel.userID;
  }

  String getUserName() {
    return _usermodel.name;
  }

  String getUserEmail() => _usermodel.email;

  String getUserSurname() => _usermodel.surname;

  String getUserTelno() => _usermodel.telno;

  String getUserBirthday() => _usermodel.birthday;

  void setUserName(String name) {
    _usermodel.name = name;
  }

  void setSurname(String surname) {
    _usermodel.surname = surname;
  }

  void setEmail(String email) {
    _usermodel.email = email;
  }

  void setBirthday(String birthday) {
    _usermodel.birthday = birthday;
  }

  void setCity(String city) {
    _usermodel.city = city;
  }

  void updateInfo(String maptext, String changedtext) {
    firebaseDatabaseWorks.updateInfo(_usermodel.userID, maptext, changedtext);
  }

  void refresh() {
    notifyListeners();
  }

// buraya getter ve setter leri tanımla
}

/*
Provider kullanımı
final  userWorker = Provider.of<UserWorker>(context);
*/
