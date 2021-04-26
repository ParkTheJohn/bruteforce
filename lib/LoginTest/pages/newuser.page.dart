import 'package:cse_115a/LoginTest/widget/buttonNewUser.dart';
import 'package:cse_115a/LoginTest/widget/newEmail.dart';
import 'package:cse_115a/LoginTest/widget/newName.dart';
import 'package:cse_115a/LoginTest/widget/password.dart';
import 'package:cse_115a/LoginTest/widget/singup.dart';
import 'package:cse_115a/LoginTest/widget/textNew.dart';
import 'package:cse_115a/LoginTest/widget/userOld.dart';
import 'package:flutter/material.dart';

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.white, Colors.lightBlue]),
        ),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    SingUp(),
                    TextNew(),
                  ],
                ),
                NewNome(),
                NewEmail(),
                PasswordInput(),
                ButtonNewUser(),
                UserOld(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
