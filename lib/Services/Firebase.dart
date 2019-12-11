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

class DatabaseWorks {
  final Firestore ref = Firestore.instance;
  DatabaseWorks() {
    print("DatabaseWorks locator running");
  }

  Future<bool> createEvent(
      String userId, Map<String, dynamic> eventData) async {
    String generatedID = AutoIdGenerator.autoId();
    try {
      await ref
          .collection("users")
          .document(userId)
          .collection("events")
          .document(generatedID)
          .setData(eventData);
      await ref
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
      return await ref.collection("activeEvents").getDocuments().then((docs) {
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

  Future<Map<String, dynamic>> getUserInfoMap(String userId) async {
    var data = await ref.collection("users").document(userId).get();
    return data.data;
  }

  Future<String> getUserProfilePhotoUrl(String userId) {
    Future<String> url;
    try {
      url = ref.collection("users").document(userId).get().then((value) {
        return value.data["ProfilePhotoUrl"].toString();
      });
    } catch (e) {
      print(e);
    }
    return url;
  }

  void updateInfo(String userId, String maptext, String changedtext) {
    ref.collection('users').document(userId).updateData({maptext: changedtext});
  }

  Future<Map<String, dynamic>> findUserbyID(String userID) async {
    try {
      return await ref
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
                .collection('users')
                .document(currentUser)
                .collection('messages')
                .document(chatID),
            {"OtherUserID": otherUser});
        await transaction.set(
            Firestore.instance
                .collection('users')
                .document(otherUser)
                .collection('messages')
                .document(chatID),
            {"OtherUserID": currentUser});
      });
    }
    var messageRef = Firestore.instance
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
        .collection('users')
        .document(currentUser)
        .collection('messages')
        .snapshots();
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

  // diğer yöntem Not working
  Future<Uint8List> getUserProfilePhoto(String userId) {
    Uint8List image;

    ref
        .child("users")
        .child(userId)
        .child("images")
        .child("profile")
        .child("ProfileImage");

    ref.getData(2 * 1024 * 1024).then((data) {
      image = data;
    });
    if (image != null)
      return image as Future<Uint8List>;
    else
      return null;
  }
}
