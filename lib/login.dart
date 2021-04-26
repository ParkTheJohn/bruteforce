library pages;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class loginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
                // child: Text("HI"),
                ),
            SizedBox(height: 20),
            RichText(
                text: TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'FitRecur',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue))
                ])),
            Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),

                      onPressed: () {},
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                      //),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                      ),

                      onPressed: () {},
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),

                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0),
                      //),
                    ),
                  ]),
            ),
            SizedBox(height: 20.0),
            SignInButton(
              Buttons.Google,
              text: "Sign up with Google",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
