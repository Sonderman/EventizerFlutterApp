import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/Services/Firebase.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';

class AuthService extends InheritedWidget {
  AuthService({Key key, this.auth, Widget child})
      : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static AuthService of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthService>();
  }
}

//REVIEW Repositorye taşınacak
class LoginAndRegister {
  String _server = DatabaseWorks().getServer();

  Future<void> registerUser(BuildContext context, String eposta, String sifre,
      List<String> datalist, File image) async {
    var auth = AuthService.of(context).auth;
    String url;
    Map<String, dynamic> data = {
      "Name": datalist[0],
      "Surname": datalist[1],
      "Email": datalist[2],
      //"ProfilePhotoUrl": "null",
      "RegisteredAt": FieldValue.serverTimestamp()
    };

    await auth.signUp(eposta, sifre).then((userId) {
      if (userId != null) {
        Firestore.instance
            .collection("EventizerApp")
            .document(_server)
            .collection('users')
            .document(userId)
            .setData(data)
            .whenComplete(() {
          StorageReference storageReference = FirebaseStorage()
              .ref()
              .child('users')
              .child(userId)
              .child('images')
              .child('profile')
              .child('ProfileImage');
          StorageUploadTask uploadTask = storageReference.putFile(image);

          StreamSubscription<StorageTaskEvent> streamSubscription =
              uploadTask.events.listen((event) {
            print('UploadingProfile Image :${event.type}');
          });

          uploadTask.onComplete.then((onValue) {
            onValue.ref.getDownloadURL().then((value) {
              url = value.toString();
              print("Url:" + url);
            }).whenComplete(() {
              Firestore.instance
                  .collection("EventizerApp")
                  .document(_server)
                  .collection('users')
                  .document(userId)
                  .updateData({"ProfilePhotoUrl": url});
            });
          }).whenComplete(() {
            streamSubscription.cancel();
          });
        }).catchError((e) {
          print(e);
        });
        //auth.sendEmailVerification();

      }
    }, onError: (e) {
      print('ERROR:Kayıt olurken hata!: $e');
    });
  }
}
