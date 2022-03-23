import 'package:flutter/material.dart';
import 'package:mcpoc/components/rounded_button.dart';
import 'package:mcpoc/screens/login/email_login_screen.dart';
import 'package:mcpoc/screens/login/phone_login_screen.dart';

class AuthSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Select Login Method',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                buttonTitle: 'Email',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, EmailLoginScreen.id);
                },
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                buttonTitle: 'Phone Number',
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, PhoneLoginScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
