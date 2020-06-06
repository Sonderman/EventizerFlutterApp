import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => user?.uid);
  }

  Future<String> signIn(String email, String password) async {
    FirebaseUser user;
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      print('Error: Giriş işleminde Hata!: $e');
    }
    return user?.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  void signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> getUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  Future<String> getUserUid() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    if (user != null)
      return user.uid;
    else
      return null;
  }

  Future<bool> checkPassword(String email, String password) async {
    String userId;
    try {
      userId = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user
          .uid;
    } catch (e) {
      return false;
    }
    if (userId != null) {
      //print("UserId: " + userId);
      return true;
    } else
      return false;
  }

  void sendPasswordResetEmail(String email) {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
}
