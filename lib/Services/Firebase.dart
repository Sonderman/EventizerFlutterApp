import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat/dash_chat.dart';
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
  // String _server = "Release";
  String _server = "Development";
  //String _server = "OpenTest";
  String getServer() => _server;
  DatabaseWorks() {
    print("DatabaseWorks locator running");
  }

  Future<bool> createEvent(
      String userId, Map<String, dynamic> eventData) async {
    String generatedID = AutoIdGenerator.autoId();
    //print("2.url:" + eventData['EventImageUrl'].toString());
    eventData['eventID'] = generatedID;
    try {
      await ref
          .collection("EventizerApp")
          .document(_server)
          .collection("users")
          .document(userId)
          .collection("events")
          .document(generatedID)
          .setData(eventData);
      await ref
          .collection("EventizerApp")
          .document(_server)
          .collection("activeEvents")
          .document(generatedID)
          .setData(eventData);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchActiveEventLists() async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection("EventizerApp")
          .document(_server)
          .collection("activeEvents")
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
      String category) async {
    try {
      List<Map<String, dynamic>> eventList = [];
      return await ref
          .collection("activeEvents")
          .where("Category", isEqualTo: category)
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

  Future<Map<String, dynamic>> getUserInfoMap(String userId) async {
    var data = await ref
        .collection("EventizerApp")
        .document(_server)
        .collection("users")
        .document(userId)
        .get();
    return data.data;
  }

  Future<String> getUserProfilePhotoUrl(String userId) {
    Future<String> url;
    try {
      url = ref
          .collection("EventizerApp")
          .document(_server)
          .collection("users")
          .document(userId)
          .get()
          .then((value) {
        return value.data["ProfilePhotoUrl"].toString();
      });
    } catch (e) {
      print(e);
    }
    return url;
  }

  void updateInfo(String userId, String maptext, String changedtext) {
    if (changedtext == "timeStamp") {
      ref
          .collection("EventizerApp")
          .document(_server)
          .collection('users')
          .document(userId)
          .updateData({maptext: FieldValue.serverTimestamp()});
    } else {
      ref
          .collection("EventizerApp")
          .document(_server)
          .collection('users')
          .document(userId)
          .updateData({maptext: changedtext});
    }
  }

  Future<Map<String, dynamic>> findUserbyID(String userID) async {
    try {
      return await ref
          .collection("EventizerApp")
          .document(_server)
          .collection("users")
          .document(userID)
          .get()
          .then((userData) {
        return userData.data;
      });
    } catch (e) {
      print(e);
      return {};
    }
  }

  Stream<QuerySnapshot> getSnapshot(String chatID) {
    return ref
        .collection("EventizerApp")
        .document(_server)
        .collection('messagePool')
        .document(chatID)
        .collection('messages')
        .snapshots();
  }

  Future sendMessage(ChatMessage message, String chatID, String currentUser,
      String otherUser) async {
    if (chatID == "temp") {
      chatID = AutoIdGenerator.autoId();

      await Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
            Firestore.instance
                .collection("EventizerApp")
                .document(_server)
                .collection('users')
                .document(currentUser)
                .collection('messages')
                .document(chatID),
            {"OtherUserID": otherUser});
        await transaction.set(
            Firestore.instance
                .collection("EventizerApp")
                .document(_server)
                .collection('users')
                .document(otherUser)
                .collection('messages')
                .document(chatID),
            {"OtherUserID": currentUser});
      });
    }
    var messageRef = Firestore.instance
        .collection("EventizerApp")
        .document(_server)
        .collection('messagePool')
        .document(chatID)
        .collection('messages')
        .document(DateTime.now().millisecondsSinceEpoch.toString());
    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        messageRef,
        message.toJson(),
      );
    }, timeout: Duration(seconds: 1));
  }

  Future<String> checkConversation(String currentUser, String otherUser) async {
    try {
      return await Firestore.instance
          .collection("EventizerApp")
          .document(_server)
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
        .collection("EventizerApp")
        .document(_server)
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
        .collection("EventizerApp")
        .document(_server)
        .collection('users')
        .document(currentUser)
        .collection('messages')
        .snapshots();
  }

//NOTE Burası Settings
  Future<List<String>> getEventCategories() {
    List<String> categories;
    return ref
        .collection("EventizerApp")
        .document(_server)
        .collection('Settings')
        .document('Event')
        .get()
        .then((eventSettings) {
      categories = List.from(eventSettings.data['Categories']);
      print(categories);
      return categories;
    });
  }

  Future<bool> joinEvent(String userID, String eventID) async {
    try {
      ref
          .collection("EventizerApp")
          .document(_server)
          .collection('activeEvents')
          .document(eventID)
          .collection('Participants')
          .document(userID)
          .setData({"ParticipantID": userID});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //ANCHOR kullanıcı bu etkinliğe kayıtlımı kontrol eder
  Future<bool> amIparticipant(String userId, String eventID) async {
    try {
      var doc = await ref
          .collection("EventizerApp")
          .document(_server)
          .collection('activeEvents')
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

  Future<bool> leaveEvent(String userID, String eventID) async {
    try {
      return await ref
          .collection("EventizerApp")
          .document(_server)
          .collection("activeEvents")
          .document(eventID)
          .collection("Participants")
          .document(userID)
          .delete()
          .then((_) {
        return true;
      });
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendComment(
      String eventID, String userID, String comment) async {
    try {
      return await ref
          .collection("EventizerApp")
          .document(_server)
          .collection("activeEvents")
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
          .collection("EventizerApp")
          .document(_server)
          .collection("activeEvents")
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
          .collection("EventizerApp")
          .document(_server)
          .collection("activeEvents")
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
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
class StorageWorks {
  final StorageReference ref = FirebaseStorage().ref();

  StorageWorks() {
    print("StorageWorks locator running");
  }

  Future<bool> updateProfilePhoto(String userId, File image) async {
    if (image == null) {
      print("image null");
    }

    String url;

    StorageUploadTask uploadTask = ref
        .child('users')
        .child(userId)
        .child('images')
        .child('profile')
        .child('ProfileImage')
        .putFile(image);

    StreamSubscription<StorageTaskEvent> streamSubscription =
        uploadTask.events.listen((event) {
      print('UpdatingProfile Image :${event.type}');
    });

    return (await uploadTask.onComplete.then((onValue) {
      onValue.ref.getDownloadURL().then((value) {
        url = value.toString();
        print("Url:" + url);
      }).whenComplete(() {
        Firestore.instance
            .collection('users')
            .document(userId)
            .updateData({"ProfilePhotoUrl": url});
      });
      return true;
    }).whenComplete(() {
      streamSubscription.cancel();
    }).catchError((e) {
      print(e);
    }));
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
