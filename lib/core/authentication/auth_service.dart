import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Stream<bool> isUserAuthenticated() {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((User? user) => user != null);
  }

  static Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  static Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  static Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
