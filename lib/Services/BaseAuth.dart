import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<String> getUserEmail();

  Future<String> getUserUid();

  Stream<String> get onAuthStateChanged;
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => user?.uid);
  }

  @override
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

  @override
  Future<String> signUp(String email, String password) async {
    FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user.uid;
  }

  @override
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  @override
  Future<String> getUserEmail() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.email;
  }

  @override
  Future<String> getUserUid() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }
}
