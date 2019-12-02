import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseWorks {
  final Firestore ref = Firestore.instance;
  DatabaseWorks() {
    print("DatabaseWorks locator running");
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
}

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
