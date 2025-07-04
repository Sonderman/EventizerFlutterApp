import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Services/AuthService.dart';
import 'package:eventizer/Services/Firebase.dart';
import 'package:eventizer/locator.dart';
import 'package:flutter/material.dart';

///UserService*****************************************************************************************************
class UserService with ChangeNotifier {
  User userModel;
  final DatabaseWorks firebaseDatabaseWorks = locator<DatabaseWorks>();
  final StorageWorks firebaseStorageWorks = locator<StorageWorks>();

  Future<bool> userInitializer(String userId) async {
    if (userId == null || userId == "") {
      userId = "0000000000000000";
      userModel = User(userID: userId);
      return Future.value(false);
    } else {
      userModel = User(userID: userId);
      return await userModelSync();
    }
  }

  Future<bool> userModelSync() async {
    try {
      return await firebaseDatabaseWorks
          .findUserbyID(userModel.getUserId())
          .then((map) {
        userModel.parseMap(map);
        //refresh();
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendFeedback(String text) async {
    return await firebaseDatabaseWorks.sendFeedback(
        text, userModel.getUserId());
  }

  Future<Map<String, dynamic>> findUserByID(String userID) {
    return firebaseDatabaseWorks.findUserbyID(userID);
  }

  Future<bool> updateProfilePhoto(Uint8List image) async {
    if (image == null) return false;
    return await firebaseStorageWorks.updateProfilePhoto(
            userModel.userID, image) ??
        false;
  }

  Future<bool> userModelUpdater(User model) async {
    return await firebaseDatabaseWorks.userModelUpdater(model);
  }

  Future<bool> updateSingleInfo(String maptext, String changedtext) async {
    bool isCompleted = false;
    await firebaseDatabaseWorks
        .updateSingleInfo(userModel.userID, maptext, changedtext)
        .whenComplete(() => isCompleted = true)
        .catchError((e) {
      print(e);
    });
    return isCompleted;
  }

  Future<bool> increaseNofEvents() async {
    return await firebaseDatabaseWorks
        .increaseNofEvents(userModel.getUserId())
        .then((value) {
      if (value) {
        userModelSync();
        return true;
      } else
        return false;
    });
  }

  Future<bool> followToggle(String otherUserID) async {
    return await firebaseDatabaseWorks.followToggle(
        userModel.userID, otherUserID);
  }

  Future<bool> amIFollowing(String otherUserID) async {
    return await firebaseDatabaseWorks.amIFollowing(
        userModel.userID, otherUserID);
  }

  Future<String> registerUser(String eposta, String sifre,
      List<String> datalist, Uint8List image) async {
    Map<String, dynamic> data = {
      "Name": datalist[0],
      "Surname": datalist[1],
      "Email": datalist[2],
      "PhoneNumber": int.parse(datalist[3]),
      "Gender": datalist[4],
      "Country": datalist[5],
      "BirthDay": datalist[6],
      "NickName": datalist[7],
      'Nof_follower': 0,
      'Nof_following': 0,
      'Nof_events': 0,
      'Nof_trustPoint': 0,
      //"ProfilePhotoUrl": "",
      "RegisteredAt": FieldValue.serverTimestamp()
    };
    try {
      AuthService auth = locator<AuthService>();
      return await auth.signUp(eposta, sifre).then((userId) async {
        if (userId != null) {
          data['UserID'] = userId;

          await firebaseDatabaseWorks.newUser(data).then((value) async {
            if (value)
              await firebaseStorageWorks.updateProfilePhoto(userId, image);
          });

          return userId;

          //TODO -  release yaparken bunu açmayı unutma
          //auth.sendEmailVerification();
        } else
          return null;
      });
    } catch (e) {
      print(e);
      return null;
    }
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

  Future<bool> deleteEvent(String eventID) {
    return firebaseDatabaseWorks.deleteEvent(eventID);
  }

  Future<bool> finishEvent(String eventID) {
    return firebaseDatabaseWorks.finishEvent(eventID);
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

  Future<List<Map<String, dynamic>>> fetchListOfUserEvents(String userID) {
    return firebaseDatabaseWorks.fetchListOfUserEvents(userID);
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventLists() {
    return firebaseDatabaseWorks.fetchActiveEventLists();
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventListsByCategory(
      String category) {
    return firebaseDatabaseWorks.fetchActiveEventListsByCategory(category);
  }

  Future<List<Map<String, dynamic>>> fetchEventListsForUser(
      String organizerID, bool isOld) {
    return firebaseDatabaseWorks.fetchEventListsForUser(organizerID, isOld);
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

  Future<String> sendMessage(String chatID, ChatMessage message,
      String currentUser, String otherUser) async {
    return await firebaseDatabaseWorks.sendMessage(
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

  Future<String> checkConversation(
      String currentUserID, String otherUserID) async {
    return await firebaseDatabaseWorks.checkConversation(
        currentUserID, otherUserID);
  }

  Stream<QuerySnapshot> getMessagesSnapshot(String chatID) {
    return firebaseDatabaseWorks.getMessagesSnapshot(chatID);
  }

  Stream<QuerySnapshot> getUserChatsSnapshot(String currentUser) {
    return firebaseDatabaseWorks.getUserChatsSnapshots(currentUser);
  }

  Stream<DocumentSnapshot> getChatPoolSnapshot(String chatID) {
    return firebaseDatabaseWorks.getChatPoolSnapshot(chatID);
  }
}

/*
Provider kullanımı
final  userService = Provider.of<UserService>(context);
*/
