import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Services/FirebaseDb.dart';
import 'package:flutter/material.dart';

class UserWorker with ChangeNotifier {
  User _usermodel;
  final StorageWorks firebaseStorageWorks;

  UserWorker(String userId, this.firebaseStorageWorks) {
    userInitializer(userId);
  }

  void userInitializer(String userId) {
    if (userId == null || userId == "") {
      userId = "0000000000000000";
      _usermodel = User(userID: userId);
    } else {
      _usermodel = User(userID: userId);

      firebaseStorageWorks.getUserProfilePhotoUrl(userId).then((value) {
        _usermodel.profilePhotoUrl = value;
        //print("ProfileImageUrl :" + value);
      }).whenComplete(() {
        notifyListeners();
      });
    }

    //notifyListeners();
  }

  void userModelUpdater(String userId) {
    notifyListeners();
  }

  String getUserProfilePhotoUrl() {
    return _usermodel.profilePhotoUrl;
  }

  String getUserId() {
    return _usermodel.userID;
  }

  String getUserName() {
    return _usermodel.userName;
  }

  void setUserName(String name) {
    _usermodel.userName = name;
    notifyListeners();
  }

// buraya getter ve setter leri tanımla
}

/*
Provider kullanımı
final  userWorker = Provider.of<UserWorker>(context);
*/
