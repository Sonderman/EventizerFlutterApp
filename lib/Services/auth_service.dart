import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((User? user) => user!.uid);
  }

  Future<String?> signIn(String email, String password) async {
    User? user;
    try {
      user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
    } catch (e) {
      print('Error: Giriş işleminde Hata!: $e');
      return null;
    }
    return user!.uid;
  }

  Future<String> signUp(String email, String password) async {
    User? user = (await _firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    return user!.uid;
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;

  void signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) await user.sendEmailVerification();
  }

  bool? isEmailVerified() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.emailVerified;
    } else {
      return null;
    }
  }

  String? getUserEmail() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.email;
    } else {
      return null;
    }
  }

  String? getUserUid() {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<bool> checkPassword(String email, String password) async {
    try {
      (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!
          .uid;
      return true;
    } catch (e) {
      return false;
    }
  }

  void sendPasswordResetEmail(String email) {
    try {
      _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }
}
