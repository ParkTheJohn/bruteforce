import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  final FirebaseAuth _firebaseAuth;

  LoginService(this._firebaseAuth);
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<String> signIn({String email, String password}) async {}

  Future<String> signOut({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
