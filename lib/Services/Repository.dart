import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Services/Firebase.dart';
import 'package:flutter/material.dart';
import '../locator.dart';

///UserService*****************************************************************************************************
class UserService with ChangeNotifier {
  User _usermodel;
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  final StorageWorks firebaseStorageWorks = locator<StorageWorks>();

  //ANCHOR buradaki userId login işleminden sonraki authcheck de provider olusturulurken geliyor
  UserService(String userId) {
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

  String getUserId() => _usermodel.userID;

  String getUserName() => _usermodel.name;

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
}

///EventService*****************************************************************************************************
class EventService with ChangeNotifier {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  final StorageWorks firebaseStorageWorks = locator<StorageWorks>();

  // ANCHOR Etkinlikten Ayrılmayı sağlar, firestore dan participant da userid yi siler
  Future<bool> leaveEvent(String userID, String eventID) async {
    return await firebaseDatabaseWorks.leaveEvent(userID, eventID);
  }

  //ANCHOR etkinliğe tıklandığıda zaten katılımcımıyız kontrol etmek için
  Future<bool> amIparticipant(String userId, String eventID) async {
    return await firebaseDatabaseWorks.amIparticipant(userId, eventID);
  }

  //ANCHOR Etkinliğe katılmak butonuna basılında veritabanına yazmak için
  Future<bool> joinEvent(String userID, String eventID) async {
    return await firebaseDatabaseWorks.joinEvent(userID, eventID);
  }

  //ANCHOR Etkinlik oluşturur
  Future<bool> createEvent(
      String userId, Map<String, dynamic> eventData, Uint8List image) async {
    String eventID;
    if (image != null) {
      eventData['EventImageUrl'] =
          await firebaseStorageWorks.sendEventImage(image);
      //print("1.url:" + eventData['EventImageUrl'].toString());
      eventID = await firebaseDatabaseWorks.createEvent(userId, eventData);
      //ANCHOR etkinlik oluştuğunda kullanıcıyı direk katılımcı yapar
      return (eventID != null && await joinEvent(userId, eventID))
          ? true
          : false;
    } else {
      eventData['EventImageUrl'] = 'none';
      eventID = await firebaseDatabaseWorks.createEvent(userId, eventData);
      return (eventID != null && await joinEvent(userId, eventID))
          ? true
          : false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventLists() {
    return firebaseDatabaseWorks.fetchActiveEventLists();
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventListsByCategory(
      String category) {
    return firebaseDatabaseWorks.fetchActiveEventListsByCategory(category);
  }

  //ANCHOR Yapılan yorumu firestore da event içerisine kaydeder
  Future<bool> sendComment(
      String eventID, String userID, String comment) async {
    return await firebaseDatabaseWorks.sendComment(eventID, userID, comment);
  }

  Future<List<Map<String, dynamic>>> getComments(String eventID) async {
    return await firebaseDatabaseWorks.getComments(eventID);
  }

  Future<List<Map<String, dynamic>>> getParticipants(String eventID) {
    return firebaseDatabaseWorks.getParticipants(eventID);
  }
}

///MessageService*****************************************************************************************************
class MessagingService with ChangeNotifier {
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  final StorageWorks firebaseStorageWorks = locator<StorageWorks>();

  Stream<QuerySnapshot> getSnapshot(String chatID) {
    return firebaseDatabaseWorks.getSnapshot(chatID);
  }

  sendMessage(String chatID, ChatMessage message, String currentUser,
      String otherUser) async {
    await firebaseDatabaseWorks.sendMessage(
        message, chatID, currentUser, otherUser);
  }

  Future sendImageMessage(File image, ChatUser user, String currentUser,
      String chatID, String time) async {
    await firebaseDatabaseWorks.sendImageMessage(
        await firebaseStorageWorks.sendImageMessage(
            image, user, currentUser, chatID, time),
        time,
        chatID);
  }

  checkConversation(String currentUserID, String otherUserID) {
    return firebaseDatabaseWorks.checkConversation(currentUserID, otherUserID);
  }

  Stream<QuerySnapshot> getUserChatsSnapshot(String currentUser) {
    return firebaseDatabaseWorks.getUserChatsSnapshots(currentUser);
  }
}

/*
Provider kullanımı
final  userService = Provider.of<UserService>(context);
*/
