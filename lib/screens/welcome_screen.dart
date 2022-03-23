import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mcpoc/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mcpoc/components/rounded_button.dart';
import 'package:mcpoc/screens/login/phone_login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mcpoc/screens/selection_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

// with SingleTickerProviderStateMixin extends the class to be a ticker controller
// "with" is a concept called mix ins... adds capabilities to your class
class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation? animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // Initialize the animation controller
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 1,
    );

    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller!);

    controller!.forward();

    //Lets us see what's happening with he animation
    controller!.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TypewriterAnimatedTextKit(
                        text: ['PIiTCh'],
                        textStyle: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Connect Without Compromise',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              buttonTitle: 'Log In',
              onPressed: () {
                /*showModalBottomSheet(
                  context: context,
                  // isScrollControlled allows us to position the bottom sheet above the keyboard
                  isScrollControlled: true,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AuthSelection(),
                    ),
                  ),
                );*/
                if (FirebaseAuth.instance.currentUser != null) {
                  Navigator.pushNamed(context, SelectionScreen.id);
                } else {
                  Navigator.pushNamed(context, PhoneLoginScreen.id);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
