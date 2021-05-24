import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chooseExercise.dart';

class LoginService {
  final FirebaseAuth _firebaseAuth;

  LoginService(this._firebaseAuth);
  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  // Returns the UID of the current user as a string
  Future<String> getCurrentUID() async {
    return (_firebaseAuth.currentUser).uid;
  }

  // Email and password Sign In
  // Checks the firebaseAuth with inputs email and password to see if they are
  // inside the authentication database
  Future<String> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      print("Invalid Login Information");
      return e.message;
    }
  }

  // Email and Password Sign Up
  // Creates a new user with inputs email and password and add them to the
  // User Info collection in Firestore
  // The email must not already be used in the database
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(await getCurrentUID())
          .set({});
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      print("Unsuccessfully Signed Up");
      return e.message;
    }
  }

  // Account Sign Out
  // Signs the user out of their current session
  Future<void> signOut() async {
    onSignout();
    await _firebaseAuth.signOut();
  }
}

void onSignout() {
  exercises = null;
}
