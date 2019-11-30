import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserWorks {
  UserWorks() {
    print("UserWorks locator running");
  }
}

class StorageWorks {
  final Firestore instance = Firestore.instance;

  StorageWorks() {
    print("StorageWorks locator running");
  }

  Future<String> getUserProfilePhotoUrl(String userId) {
    Future<String> url;
    try {
      url = instance.collection("users").document(userId).get().then((value) {
        return value.data["ProfilePhotoUrl"].toString();
      });
    } catch (e) {
      print(e);
    }
    return url;
  }

  // diğer yöntem Not working
  Future<Uint8List> getUserProfilePhoto(String userId) {
    Uint8List image;
    StorageReference ref = FirebaseStorage.instance
        .ref()
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
