import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    /*Map<String, dynamic> dataMap;
    instance.collection("users").document(userId).get().then((data) {
      dataMap = data.data;
    }).whenComplete(() {
      print("Ad : " + dataMap["Name"]);
    });*/
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
