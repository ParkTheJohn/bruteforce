library pages;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class exercisesPage extends StatelessWidget{
  String exercise = "hello";
  int currentExer = 0;
  Future<void> exerciseClick() async {
    final QuerySnapshot result =
    await FirebaseFirestore.instance.collection('Exercises').get();
    final List<DocumentSnapshot> documents = result.docs;
    exercise = documents[currentExer]['name'];
    // print(exercise);
  }
  Widget build(BuildContext context) {
    print(exercise);
    return new Scaffold(
      body: Text(exercise),
    );
  }
}