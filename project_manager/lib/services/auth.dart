import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_manager/models/user.dart';
import 'package:project_manager/services/database.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on Firebase user
HandmadeUser? _userFromFirebaseUser(User? user) {
  return user != null ? HandmadeUser(uid: user.uid) : null;
}



  // Auth change user stream
Stream<HandmadeUser?> get user {
  return _auth.authStateChanges().map(_userFromFirebaseUser);
} 



  // Sign in anonymously
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email/password
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register with email/password
  Future registerWithEmailPassword(String email, String password) async {
    try {
      //AuthResult == UserCredential
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //User == FirebaseUser
      User? user = result.user;

      // Create a new document for the user with the uid
      await DatabaseService(uid: user!.uid).updateUserData('1', 'new new crew member', 50);

      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
