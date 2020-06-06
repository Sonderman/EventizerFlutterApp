import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Settings/AppSettings.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 20;

  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    final int maxRandom = _AUTO_ID_ALPHABET.length;

    for (int i = 0; i < _AUTO_ID_LENGTH; ++i) {
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
class DatabaseWorks {
  final Firestore ref = Firestore.instance;
  AppSettings settings = AppSettings();

  DatabaseWorks() {
    print("DatabaseWorks locator running");
  }

  Future<bool> newUser(Map<String, dynamic> data) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection('users')
          .document(data['UserID'])
          .setData(data)
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> userModelUpdater(User model) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("users")
          .document(model.getUserId())
          .updateData(model.toMap())
          .then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> amIFollowing(String userID, String otherUserID) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("users")
          .document(userID)
          .collection("following")
          .getDocuments()
          .then((onValue) {
        if (onValue.documents.isNotEmpty)
          return true;
        else
          return false;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> followToggle(String userID, String otherUserID) async {
    bool issuccesfull = false;
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("users")
          .document(userID)
          .collection("following")
          .getDocuments()
          .then((onValue) async {
        if (onValue.documents.isNotEmpty) {
          await ref.runTransaction((transaction) async {
            await transaction.delete(ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection('users')
                .document(userID)
                .collection('following')
                .document(otherUserID));

            await transaction.delete(ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection('users')
                .document(otherUserID)
                .collection('followers')
                .document(userID));
            await transaction.update(
                ref
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(otherUserID),
                {"Nof_follower": FieldValue.increment(-1)});
            await transaction.update(
                ref
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(userID),
                {"Nof_following": FieldValue.increment(-1)});
          }).whenComplete(() {
            print("Takipten çıkıldı");
            issuccesfull = true;
          });
        } else {
          await ref.runTransaction((transaction) async {
            await transaction.set(
                ref
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(userID)
                    .collection('following')
                    .document(otherUserID),
                {"OtherUserID": otherUserID});

            await transaction.set(
                ref
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(otherUserID)
                    .collection('followers')
                    .document(userID),
                {"OtherUserID": userID});

            await transaction.update(
                ref
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(otherUserID),
                {"Nof_follower": FieldValue.increment(1)});
            await transaction.update(
                ref
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(userID),
                {"Nof_following": FieldValue.increment(1)});
          }).whenComplete(() {
            print("Takip Ediliyor");
            issuccesfull = true;
          });
        }
        return issuccesfull;
      });
    } catch (e) {
      print("Error at followToggle : " + e);
      return null;
    }
  }

  Future<String> createEvent(
      String userId, Map<String, dynamic> eventData) async {
    String generatedID = AutoIdGenerator.autoId();
    //print("2.url:" + eventData['EventImageUrl'].toString());
    eventData['eventID'] = generatedID;
    try {
      await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("users")
          .document(userId)
          .collection("events")
          .document(generatedID)
          .setData(eventData);
      await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .document(generatedID)
          .setData(eventData);
      return generatedID;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchListOfUserEvents(
      String userID) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .where("OrganizerID", isEqualTo: userID)
          .where("Status", isEqualTo: "Accepted")
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((event) {
          eventList.add(event.data);
        });
        return eventList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchEventListsForUser(
      String organizerID, bool isOld) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      if (isOld) {
        return await ref
            .collection(settings.appName)
            .document(settings.getServer())
            .collection("finishedEvents")
            .where("OrganizerID", isEqualTo: organizerID)
            .getDocuments()
            .then((docs) {
          // print("gelen verinin uzunluğu:" + docs.documents.length.toString());
          docs.documents.forEach((event) {
            if (event.data["Status"] != "Deleted") eventList.add(event.data);
          });
          return eventList;
        });
      } else {
        return await ref
            .collection(settings.appName)
            .document(settings.getServer())
            .collection("Events")
            .where("OrganizerID", isEqualTo: organizerID)
            .getDocuments()
            .then((docs) {
          // print("gelen verinin uzunluğu:" + docs.documents.length.toString());
          docs.documents.forEach((event) {
            if (event.data["Status"] != "Deleted") eventList.add(event.data);
          });
          return eventList;
        });
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventLists() async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .where("Status", isEqualTo: "Accepted")
          .getDocuments()
          .then((docs) {
        // print("gelen verinin uzunluğu:" + docs.documents.length.toString());
        docs.documents.forEach((event) {
          eventList.add(event.data);
        });
        return eventList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventListsByCategory(
      String subCategory) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .where("SubCategory", isEqualTo: subCategory)
          .where("Status", isEqualTo: "Accepted")
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((event) {
          eventList.add(event.data);
        });
        return eventList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> getUserProfilePhotoUrl(String userId) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("users")
          .document(userId)
          .get()
          .then((value) {
        return value.data["ProfilePhotoUrl"].toString();
      });
    } catch (e) {
      print(e);
      return "null";
    }
  }

  //ANCHOR burada sadece 1 veride değişiklik yapar
  Future<void> updateSingleInfo(
      String userId, String maptext, String changedtext) async {
    if (changedtext == "timeStamp") {
      await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection('users')
          .document(userId)
          .updateData({maptext: FieldValue.serverTimestamp()});
    } else {
      await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection('users')
          .document(userId)
          .updateData({maptext: changedtext});
    }
  }

  Future<Map<String, dynamic>> findUserbyID(String userID) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("users")
          .document(userID)
          .get()
          .then((userData) {
        return userData.data;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot> getMessagesSnapshot(String chatID) {
    return ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('messagePool')
        .document(chatID)
        .collection('messages')
        .snapshots();
  }

  Stream<DocumentSnapshot> getChatPoolSnapshot(String chatID) {
    return ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('messagePool')
        .document(chatID)
        .snapshots();
  }

  Future sendMessage(ChatMessage message, String chatID, String currentUser,
      String otherUser) async {
    if (chatID == "temp") {
      chatID = AutoIdGenerator.autoId();
      await ref.runTransaction((transaction) async {
        await transaction.set(
            ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection('users')
                .document(currentUser)
                .collection('messages')
                .document(chatID),
            {"OtherUserID": otherUser});
        await transaction.set(
            ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection('users')
                .document(otherUser)
                .collection('messages')
                .document(chatID),
            {"OtherUserID": currentUser});
      });
    }
    var messageRef = ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('messagePool')
        .document(chatID)
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());
    Map<String, dynamic> messageMap = message.toJson();
    ref.runTransaction((transaction) async {
      await transaction.set(
        messageRef,
        messageMap,
      );
      await transaction.set(
        ref
            .collection(settings.appName)
            .document(settings.getServer())
            .collection('messagePool')
            .document(chatID),
        {
          "LastMessage": {
            "SenderID": currentUser,
            "Message": messageMap['text'],
            "createdAt": messageMap['createdAt']
          }
        },
      );
    }, timeout: Duration(seconds: 1));
  }

  Future<String> checkConversation(String currentUser, String otherUser) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection('users')
          .document(currentUser)
          .collection('messages')
          .where("OtherUserID", isEqualTo: otherUser)
          .limit(1)
          .getDocuments()
          .then((data) {
        return data.documents.first.documentID;
      });
    } catch (e) {
      print(e);
      return "bos";
    }
  }

  Future sendImageMessage(
      ChatMessage message, String time, String chatID) async {
    var messageRef = ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('messagePool')
        .document(chatID)
        .collection('messages')
        .document(time);

    await ref.runTransaction((transaction) async {
      await transaction.set(
        messageRef,
        message.toJson(),
      );
    });
  }

  Stream<QuerySnapshot> getUserChatsSnapshots(String currentUser) {
    return ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('users')
        .document(currentUser)
        .collection('messages')
        .snapshots();
  }

//NOTE Burası EventSettings
  Future<List<String>> getEventCategories() async {
    List<String> categories = [];
    return await ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('Settings')
        .document('Event')
        .get()
        .then((eventSettings) {
      Map<String, dynamic> temp;
      temp = eventSettings.data['Category'];
      temp.forEach((key, value) {
        categories.add(key);
      });
      print(categories);
      return categories;
    });
  }

  //NOTE Burası EventSettings
  Future<List<List<String>>> getEventSubCategories() async {
    List<List<String>> subCategories = [];
    return await ref
        .collection(settings.appName)
        .document(settings.getServer())
        .collection('Settings')
        .document('Event')
        .get()
        .then((eventSettings) {
      Map<String, dynamic> temp;
      temp = eventSettings.data['Category'];
      temp.forEach((key, value) {
        subCategories.add(List<String>.from(value));
      });
      return subCategories;
    });
  }

  Future<bool> joinEvent(String userID, String eventID) async {
    try {
      return ref.runTransaction((transaction) async {
        await transaction.set(
            ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection('Events')
                .document(eventID)
                .collection('Participants')
                .document(userID),
            {"ParticipantID": userID});

        await transaction.update(
            ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection("Events")
                .document(eventID),
            {"CurrentParticipantNumber": FieldValue.increment(1)});
      }).then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> leaveEvent(String userID, String eventID) async {
    try {
      return ref.runTransaction((transaction) async {
        await transaction.update(
            ref
                .collection(settings.appName)
                .document(settings.getServer())
                .collection("Events")
                .document(eventID),
            {"CurrentParticipantNumber": FieldValue.increment(-1)});
        await transaction.delete(ref
            .collection(settings.appName)
            .document(settings.getServer())
            .collection("Events")
            .document(eventID)
            .collection("Participants")
            .document(userID));
      }).then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  //ANCHOR kullanıcı bu etkinliğe kayıtlımı kontrol eder
  Future<bool> amIparticipant(String userId, String eventID) async {
    try {
      var doc = await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection('Events')
          .document(eventID)
          .collection('Participants')
          .document(userId)
          .get();
      return doc.exists && doc.data != null ? true : false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendComment(
      String eventID, String userID, String comment) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .document(eventID)
          .collection("Comments")
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({"Comment": comment, "CommentOwnerID": userID}).then((_) {
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getComments(String eventID) async {
    List<Map<String, dynamic>> commmentList = [];
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .document(eventID)
          .collection("Comments")
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((comment) {
          commmentList.add(comment.data);
        });
        //print("Comments:" + commmentList.toString());
        return commmentList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getParticipants(String eventID) async {
    List<Map<String, dynamic>> participants = [];
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .document(eventID)
          .collection("Participants")
          .getDocuments()
          .then((docs) {
        docs.documents.forEach((participant) {
          participants.add(participant.data);
        });
        //print("Comments:" + commmentList.toString());
        return participants;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteEvent(String eventID) async {
    try {
      return await ref
          .collection(settings.appName)
          .document(settings.getServer())
          .collection("Events")
          .document(eventID)
          .updateData({"Status": "Deleted"}).then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
class StorageWorks {
  final StorageReference ref = FirebaseStorage().ref();
  AppSettings settings = AppSettings();
  StorageWorks() {
    print("StorageWorks locator running");
  }

  Future<bool> updateProfilePhoto(String userId, Uint8List image) async {
    if (image == null) {
      print("image null");
    }
    StorageUploadTask uploadTask = ref
        .child('users')
        .child(userId)
        .child('images')
        .child('profile')
        .child('ProfileImage')
        .putData(image);

    try {
      return await uploadTask.onComplete.then((value) async {
        return await value.ref.getDownloadURL().then((url) async {
          return await Firestore.instance
              .collection(settings.appName)
              .document(settings.getServer())
              .collection('users')
              .document(userId)
              .updateData({"ProfilePhotoUrl": url}).then((value) => true);
        });
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future sendImageMessage(File image, ChatUser user, String currentUser,
      String chatID, String time) async {
    final StorageReference storageRef =
        ref.child("users").child(currentUser).child("images").child(time);

    StorageUploadTask uploadTask = storageRef.putFile(
      image,
      StorageMetadata(
        contentType: 'image/jpg',
      ),
    );
    StorageTaskSnapshot download = await uploadTask.onComplete;

    return await download.ref.getDownloadURL().then((url) {
      ChatMessage message = ChatMessage(text: "", user: user, image: url);
      return message;
    });
  }

  Future<String> sendEventImage(Uint8List image) async {
    String url;
    StorageUploadTask uploadTask = ref
        .child('events')
        .child('images')
        .child(AutoIdGenerator.autoId() + '.jpeg')
        .putData(image);

    StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('UpdatingProfile Image :${event.type}');
    });

    return await uploadTask.onComplete.then((onValue) {
      return onValue.ref.getDownloadURL().then((value) {
        url = value.toString();
        print("Gelen Url:" + url);
        streamSubscription.cancel();
        return value.toString();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
