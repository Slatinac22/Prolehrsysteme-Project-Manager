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



  // Sign out
  Future signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
