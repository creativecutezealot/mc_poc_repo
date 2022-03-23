import 'package:mcpoc/constants.dart';
import 'package:flutter/material.dart';
import 'package:mcpoc/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mcpoc/screens/selection_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EmailLoginScreen extends StatefulWidget {
  static const String id = 'email_login_screen';
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  String? _email;
  String? _password;
  final _auth = FirebaseAuth.instance;
  User? loggedInUser;
  bool showSpinner = false;

  void handleSignIn() async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: _email as String, password: _password as String);
      Navigator.pushNamed(context, SelectionScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print('Error: $e');
      }
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
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                autofocus: true,
                onChanged: (value) {
                  _email = value;
                },
                decoration:
                    kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your password'),
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
                    showSpinner = false;
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
