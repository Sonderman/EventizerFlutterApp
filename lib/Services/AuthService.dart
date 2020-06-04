import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventizer/Services/BaseAuth.dart';
import 'package:eventizer/Settings/AppSettings.dart';
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
  AppSettings settings = AppSettings();

  //TODO kayıt olma işlemi repository e taşınacak
  Future<bool> registerUser(BuildContext context, String eposta, String sifre,
      List<String> datalist, File image) async {
    var auth = AuthService.of(context).auth;
    String url;
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
      "RegisteredAt": FieldValue.serverTimestamp()
    };
    try {
      await auth.signUp(eposta, sifre).then((userId) async {
        if (userId != null) {
          data['UserID'] = userId;
          await Firestore.instance
              .collection(settings.appName)
              .document(settings.getServer())
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
                    .collection(settings.appName)
                    .document(settings.getServer())
                    .collection('users')
                    .document(userId)
                    .updateData({"ProfilePhotoUrl": url});
              });
            }).whenComplete(() {
              streamSubscription.cancel();
            });
          });

          //TODO -  release yaparken bunu açmayı unutma
          //auth.sendEmailVerification();
        }
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
