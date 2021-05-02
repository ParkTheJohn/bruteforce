library pages;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class myPlansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text(
          'You currently have no plans :(\nPress + to make a new plan!',
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('create new plan');
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}