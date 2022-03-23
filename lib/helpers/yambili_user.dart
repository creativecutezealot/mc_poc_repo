import 'package:firebase_auth/firebase_auth.dart';

class YambiliUser {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool _isSignedIn;

  YambiliUser(this._isSignedIn) {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user is User) {
        _isSignedIn = true;
      } else {
        _isSignedIn = false;
      }
    });
  }
}
