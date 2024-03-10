import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:eventizer/Models/UserModel.dart';
import 'package:eventizer/Settings/AppSettings.dart';
import 'package:eventizer/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 20;

  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  static final Random _random = Random();

  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = _AUTO_ID_ALPHABET.length;

    for (int i = 0; i < _AUTO_ID_LENGTH; ++i) {
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);
    }

    return stringBuffer.toString();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
class DatabaseWorks {
  final FirebaseFirestore ref = FirebaseFirestore.instance;
  AppSettings settings = locator<AppSettings>();

  DatabaseWorks() {
    print("DatabaseWorks locator running");
  }

  Future<bool> newUser(Map<String, dynamic> data) async {
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection('users')
          .doc(data['UserID'])
          .set(data)
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
          .doc(settings.getServer())
          .collection("users")
          .doc(model.getUserId())
          .update(model.toMap())
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
          .doc(settings.getServer())
          .collection("users")
          .doc(userID)
          .collection("following")
          .where("OtherUserID", isEqualTo: otherUserID)
          .get()
          .then((onValue) {
        if (onValue.docs.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> increaseNofEvents(String userID) async {
    try {
      await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection('users')
          .doc(userID)
          .update({"Nof_events": FieldValue.increment(1)});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool?> followToggle(String userID, String otherUserID) async {
    bool issuccesfull = false;
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("users")
          .doc(userID)
          .collection("following")
          .where("OtherUserID", isEqualTo: otherUserID)
          .get()
          .then((onValue) async {
        if (onValue.docs.isNotEmpty) {
          await ref.runTransaction((transaction) async {
            transaction.delete(ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection('users')
                .doc(userID)
                .collection('following')
                .doc(otherUserID));

            transaction.delete(ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection('users')
                .doc(otherUserID)
                .collection('followers')
                .doc(userID));
            transaction.update(
                ref
                    .collection(settings.appName)
                    .doc(settings.getServer())
                    .collection('users')
                    .doc(otherUserID),
                {"Nof_follower": FieldValue.increment(-1)});
            transaction.update(
                ref
                    .collection(settings.appName)
                    .doc(settings.getServer())
                    .collection('users')
                    .doc(userID),
                {"Nof_following": FieldValue.increment(-1)});
          }).whenComplete(() {
            print("Takipten çıkıldı");
            issuccesfull = true;
          });
        } else {
          await ref.runTransaction((transaction) async {
            transaction.set(
                ref
                    .collection(settings.appName)
                    .doc(settings.getServer())
                    .collection('users')
                    .doc(userID)
                    .collection('following')
                    .doc(otherUserID),
                {"OtherUserID": otherUserID});

            transaction.set(
                ref
                    .collection(settings.appName)
                    .doc(settings.getServer())
                    .collection('users')
                    .doc(otherUserID)
                    .collection('followers')
                    .doc(userID),
                {"OtherUserID": userID});

            transaction.update(
                ref
                    .collection(settings.appName)
                    .doc(settings.getServer())
                    .collection('users')
                    .doc(otherUserID),
                {"Nof_follower": FieldValue.increment(1)});
            transaction.update(
                ref
                    .collection(settings.appName)
                    .doc(settings.getServer())
                    .collection('users')
                    .doc(userID),
                {"Nof_following": FieldValue.increment(1)});
          }).whenComplete(() {
            print("Takip Ediliyor");
            issuccesfull = true;
          });
        }
        return issuccesfull;
      });
    } catch (e) {
      print("Error at followToggle : $e");
      return null;
    }
  }

  Future<String?> createEvent(
      String userId, Map<String, dynamic> eventData) async {
    String generatedID = AutoIdGenerator.autoId();
    //print("2.url:" + eventData['EventImageUrl'].toString());
    eventData['eventID'] = generatedID;
    //TODO - Release alırken bunu kaldır!!
    eventData['Status'] = "Accepted";
    try {
      await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("users")
          .doc(userId)
          .collection("events")
          .doc(generatedID)
          .set(eventData);
      await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .doc(generatedID)
          .set(eventData);
      return generatedID;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchListOfUserEvents(
      String userID) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .where("OrganizerID", isEqualTo: userID)
          .where("Status", isEqualTo: "Accepted")
          .get()
          .then((docs) {
        for (var event in docs.docs) {
          eventList.add(event.data());
        }
        return eventList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchEventListsForUser(
      String organizerID, bool isOld) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      if (isOld) {
        return await ref
            .collection(settings.appName)
            .doc(settings.getServer())
            .collection("Events")
            .where("OrganizerID", isEqualTo: organizerID)
            .get()
            .then((docs) {
          for (var event in docs.docs) {
            if (event.data()["Status"] != "Deleted" &&
                event.data()["Status"] == "Finished") {
              eventList.add(event.data());
            }
          }
          return eventList;
        });
      } else {
        return await ref
            .collection(settings.appName)
            .doc(settings.getServer())
            .collection("Events")
            .where("OrganizerID", isEqualTo: organizerID)
            .get()
            .then((docs) {
          for (var event in docs.docs) {
            if (event.data()["Status"] != "Deleted" &&
                event.data()["Status"] != "Finished") {
              eventList.add(event.data());
            }
          }
          return eventList;
        });
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchActiveEventLists() async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .where("Status", isEqualTo: "Accepted")
          .get()
          .then((docs) {
        // print("gelen verinin uzunluğu:" + docs.docs.length.toString());
        for (var event in docs.docs) {
          eventList.add(event.data());
        }
        return eventList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchActiveEventListsByCategory(
      String subCategory) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .where("SubCategory", isEqualTo: subCategory)
          .where("Status", isEqualTo: "Accepted")
          .get()
          .then((docs) {
        for (var event in docs.docs) {
          eventList.add(event.data());
        }
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
          .doc(settings.getServer())
          .collection("users")
          .doc(userId)
          .get()
          .then((value) {
        return value.data()!["ProfilePhotoUrl"].toString();
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
          .doc(settings.getServer())
          .collection('users')
          .doc(userId)
          .update({maptext: FieldValue.serverTimestamp()});
    } else {
      await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection('users')
          .doc(userId)
          .update({maptext: changedtext});
    }
  }

  Future<Map<String, dynamic>?> findUserbyID(String userID) async {
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("users")
          .doc(userID)
          .get()
          .then((userData) {
        return userData.data();
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesSnapshot(
      String chatID) {
    return ref
        .collection(settings.appName)
        .doc(settings.getServer())
        .collection('messagePool')
        .doc(chatID)
        .collection('messages')
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatPoolSnapshot(
      String chatID) {
    return ref
        .collection(settings.appName)
        .doc(settings.getServer())
        .collection('messagePool')
        .doc(chatID)
        .snapshots();
  }

  Future<String> sendMessage(ChatMessage message, String chatID,
      String currentUser, String otherUser) async {
    if (chatID == "temp") {
      chatID = AutoIdGenerator.autoId();
      await ref.runTransaction((transaction) async {
        transaction.set(
            ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection('users')
                .doc(currentUser)
                .collection('messages')
                .doc(chatID),
            {"OtherUserID": otherUser});
        transaction.set(
            ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection('users')
                .doc(otherUser)
                .collection('messages')
                .doc(chatID),
            {"OtherUserID": currentUser});
      });
    }
    var messageRef = ref
        .collection(settings.appName)
        .doc(settings.getServer())
        .collection('messagePool')
        .doc(chatID)
        .collection('messages')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    Map<String, dynamic> messageMap = message.toJson();
    ref.runTransaction((transaction) async {
      transaction.set(
        messageRef,
        messageMap,
      );
      transaction.set(
        ref
            .collection(settings.appName)
            .doc(settings.getServer())
            .collection('messagePool')
            .doc(chatID),
        {
          "LastMessage": {
            "SenderID": currentUser,
            "Message": messageMap['text'],
            "createdAt": messageMap['createdAt']
          }
        },
      );
    }, timeout: const Duration(seconds: 1));
    return chatID;
  }

  Future<String> checkConversation(String currentUser, String otherUser) async {
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection('users')
          .doc(currentUser)
          .collection('messages')
          .where("OtherUserID", isEqualTo: otherUser)
          .limit(1)
          .get()
          .then((data) {
        return data.docs.first.id;
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
        .doc(settings.getServer())
        .collection('messagePool')
        .doc(chatID)
        .collection('messages')
        .doc(time);

    await ref.runTransaction((transaction) async {
      transaction.set(
        messageRef,
        message.toJson(),
      );
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatsSnapshots(
      String currentUser) {
    return ref
        .collection(settings.appName)
        .doc(settings.getServer())
        .collection('users')
        .doc(currentUser)
        .collection('messages')
        .snapshots();
  }

//NOTE Burası EventSettings
  Future<List<String>> getEventCategories() async {
    List<String> categories = [];
    return await ref
        .collection(settings.appName)
        .doc(settings.getServer())
        .collection('Settings')
        .doc('Event')
        .get()
        .then((eventSettings) {
      Map<String, dynamic> temp;
      temp = eventSettings.data()!['Category'];
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
        .doc(settings.getServer())
        .collection('Settings')
        .doc('Event')
        .get()
        .then((eventSettings) {
      Map<String, dynamic> temp;
      temp = eventSettings.data()!['Category'];
      temp.forEach((key, value) {
        subCategories.add(List<String>.from(value));
      });
      return subCategories;
    });
  }

  Future<bool> joinEvent(String userID, String eventID) async {
    try {
      return ref.runTransaction((transaction) async {
        transaction.set(
            ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection('Events')
                .doc(eventID)
                .collection('Participants')
                .doc(userID),
            {"ParticipantID": userID});

        transaction.update(
            ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection("Events")
                .doc(eventID),
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
        transaction.update(
            ref
                .collection(settings.appName)
                .doc(settings.getServer())
                .collection("Events")
                .doc(eventID),
            {"CurrentParticipantNumber": FieldValue.increment(-1)});
        transaction.delete(ref
            .collection(settings.appName)
            .doc(settings.getServer())
            .collection("Events")
            .doc(eventID)
            .collection("Participants")
            .doc(userID));
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
          .doc(settings.getServer())
          .collection('Events')
          .doc(eventID)
          .collection('Participants')
          .doc(userId)
          .get();
      return doc.exists ? true : false;
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
          .doc(settings.getServer())
          .collection("Events")
          .doc(eventID)
          .collection("Comments")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({"Comment": comment, "CommentOwnerID": userID}).then((_) {
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getComments(String eventID) async {
    List<Map<String, dynamic>> commmentList = [];
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .doc(eventID)
          .collection("Comments")
          .get()
          .then((docs) {
        for (var comment in docs.docs) {
          commmentList.add(comment.data());
        }
        //print("Comments:" + commmentList.toString());
        return commmentList;
      });
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> getParticipants(String eventID) async {
    List<Map<String, dynamic>> participants = [];
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .doc(eventID)
          .collection("Participants")
          .get()
          .then((docs) {
        for (var participant in docs.docs) {
          participants.add(participant.data());
        }
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
          .doc(settings.getServer())
          .collection("Events")
          .doc(eventID)
          .update({"Status": "Deleted"}).then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> finishEvent(String eventID) async {
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Events")
          .doc(eventID)
          .update({"Status": "Finished"}).then((value) => true);
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendFeedback(String text, String userID) async {
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .collection("Feedbacks")
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set({
        "Feedback": text,
        "FeedbackOwnerID": userID,
        "Created At:": FieldValue.serverTimestamp()
      }).then((_) {
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<String?> getServerVersion() async {
    try {
      return await ref
          .collection(settings.appName)
          .doc(settings.getServer())
          .get()
          .then((value) {
        return value.data()!["Version"];
      });
    } catch (e) {
      print(e);
      return null;
    }
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
class StorageWorks {
  final ref = FirebaseStorage.instance;
  AppSettings settings = locator<AppSettings>();
  StorageWorks() {
    print("StorageWorks locator running");
  }

  Future<bool> updateProfilePhoto(String userId, Uint8List? image) async {
    if (image == null) {
      print("image null");
      return false;
    }
    UploadTask uploadTask = ref
        .ref()
        .child('users')
        .child(userId)
        .child('images')
        .child('profile')
        .child('ProfileImage')
        .putData(image);

    try {
      return await uploadTask.then((value) async {
        return await value.ref.getDownloadURL().then((url) async {
          return await FirebaseFirestore.instance
              .collection(settings.appName)
              .doc(settings.getServer())
              .collection('users')
              .doc(userId)
              .update({"ProfilePhotoUrl": url}).then((value) => true);
        });
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future sendImageMessage(File image, ChatUser user, String currentUser,
      String chatID, String time) async {
    final storageRef =
        ref.ref().child("users").child(currentUser).child("images").child(time);

    UploadTask uploadTask = storageRef.putFile(
      image,
      SettableMetadata(
        contentType: 'image/jpg',
      ),
    );
    TaskSnapshot download = await uploadTask.then((task) => task);
    return await download.ref.getDownloadURL().then((url) {
      ChatMessage message = ChatMessage(
          text: "",
          user: user,
          medias: [
            ChatMedia(
                url: url, fileName: "Profile Picture", type: MediaType.image)
          ],
          createdAt: DateTime.now());
      return message;
    });
  }

  Future<String> sendEventImage(Uint8List image) async {
    String url;
    UploadTask uploadTask = ref
        .ref()
        .child('events')
        .child('images')
        .child('${AutoIdGenerator.autoId()}.jpeg')
        .putData(image);

    StreamSubscription<TaskSnapshot> streamSubscription =
        uploadTask.asStream().listen((event) {
      print('UpdatingProfile Image :${event.bytesTransferred}');
    });

    return await uploadTask.then((onValue) {
      return onValue.ref.getDownloadURL().then((value) {
        url = value.toString();
        print("Gelen Url:$url");
        streamSubscription.cancel();
        return value.toString();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
