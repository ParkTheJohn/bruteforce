// library pages;

// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'LoginService.dart';

class settingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Text("Welcome to FitRecur"),
                RaisedButton(
                  onPressed: () {
                    context.read<LoginService>().signOut();
                  },
                  child: Text("Sign out"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
