import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<String> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map((User? user) => user!.uid);
  }

  Future<String> signIn(String email, String password) async {
    // Hatalar yutulmaz — çağıran, authErrorMessage ile kullanıcıya
    // Türkçe mesaj gösterir (wrong-password vs. network hatası ayrışır).
    final user = (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
    return user.uid;
  }

  /// Firebase hata kodunu kullanıcıya gösterilebilir Türkçe mesaja çevirir.
  static String authErrorMessage(Object error) {
    if (error is! FirebaseAuthException) {
      return 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.';
    }
    switch (error.code) {
      case 'invalid-email':
        return 'Geçerli bir e-posta adresi girin.';
      case 'invalid-credential':
      case 'wrong-password':
        return 'E-posta adresi veya şifre hatalı.';
      case 'user-not-found':
        return 'Bu e-posta adresiyle kayıtlı bir hesap bulunamadı.';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kayıtlı.';
      case 'weak-password':
        return 'Şifre çok zayıf — en az 6 karakter kullanın.';
      case 'too-many-requests':
        return 'Çok fazla deneme yaptınız. Lütfen birazdan tekrar deneyin.';
      case 'network-request-failed':
        return 'İnternet bağlantınızı kontrol edin.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda kullanılamıyor.';
      case 'requires-recent-login':
        return 'Güvenlik için lütfen tekrar giriş yapın.';
      default:
        return 'Bir hata oluştu: ${error.message ?? error.code}';
    }
  }

  Future<String> signUp(String email, String password) async {
    User? user = (await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user!.uid;
  }

  Future<void> deleteCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  User? getCurrentUser() => _firebaseAuth.currentUser;

  Future<void> signOut() async {
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
      (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!.uid;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Şifre sıfırlama maili gönderir; hata durumunda exception fırlatır
  /// (çağıran taraf kullanıcıya gösterebilir).
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
