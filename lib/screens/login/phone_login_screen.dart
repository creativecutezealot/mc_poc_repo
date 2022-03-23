import 'package:mcpoc/constants.dart';
import 'package:flutter/material.dart';
import 'package:mcpoc/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mcpoc/screens/home_screen.dart';
import 'package:mcpoc/screens/selection_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhoneLoginScreen extends StatefulWidget {
  static const String id = 'phone_login_screen';
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  String? _phone;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  bool showSpinner = false;

  void handleSignIn() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: _phone as String,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // ANDROID ONLY!
          print('verification completed');
          // Sign the user in (or link) with the auto-generated credential
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } else {
            // Handle other errors
            print(e);
          }
        },
        codeSent: (String? verificationId, int? resendToken) async {
          String? _smsCode;
          setState(() {
            showSpinner = false;
          });
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Enter SMS Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      _smsCode = value;
                    },
                    decoration:
                        kTextFieldDecoration.copyWith(hintText: 'XXXXXX'),
                  ),
                ],
              ),
              actions: [
                FlatButton(
                  child: Text('Done'),
                  textColor: Colors.white,
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    // Create a PhoneAuthCredential with the code
                    PhoneAuthCredential phoneAuthCredential =
                        PhoneAuthProvider.credential(
                            verificationId: verificationId as String, smsCode: _smsCode as String);

                    try {
                      // Sign the user in (or link) with the credential
                      await _auth
                          .signInWithCredential(phoneAuthCredential)
                          .then(
                        (result) {
                          print('user is: ${result.user.toString()}');
                        },
                      );
                      Navigator.popAndPushNamed(context, SelectionScreen.id);
                    } catch (e) {
                      print(e);
                    }
                  },
                )
              ],
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              Text(
                'Enter your phone number',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _phone = '+1' + value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'XXX-XXX-XXXX'),
              ),
              SizedBox(
                height: 32.0,
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                buttonTitle: 'Log In',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  handleSignIn();
                  setState(() {
                    //showSpinner = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
