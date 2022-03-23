import 'package:firebase_auth/firebase_auth.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  Auth() {
    this._firebaseAuth = FirebaseAuth.instance;
  }

  Future<bool> isLoggedIn() async {
    this._user = _firebaseAuth.currentUser;
    if (this._user == null) {
      return false;
    }
    return true;
  }

  // Future<bool> authenticateWithGoogle() async {
  //   final googleSignIn = GoogleSignIn();
  //   final GoogleSignInAccount googleUser = await googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser.authentication;
  //   this._user = await _firebaseAuth.signInWithGoogle(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );
  //   if (this._user == null) {
  //     return false;
  //   }
  //   return true;
  //   // do something with signed-in user
  // }
}
