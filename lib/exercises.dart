//library pages;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'searchBar.dart';

class exercisesPage extends StatelessWidget {
  List<List<String>> exercises = [];
  Future<void> getExerciseData() async {
    if (exercises.length != 0) return exercises;
    List<String> exerciseNames = [];
    List<String> exerciseDescription = [];

    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Exercise_List').get();
    final List<DocumentSnapshot> documents = result.docs;

    final QuerySnapshot result2 = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('customExercises')
        .get();
    final List<DocumentSnapshot> customDoc = result2.docs;

    for (int i = 0; i < customDoc.length; i++) {
      exerciseNames.add(customDoc[i]['name']);
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
    }

    for (int i = 0; i < customDoc.length; i++) {
      exerciseDescription.add(customDoc[i]['description']);
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseDescription.add(documents[i]['description']);
    }

    await exercises.add(exerciseNames);
    await exercises.add(exerciseDescription);

    return exercises;
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          return ExerciseSearch(exercises[0], exercises[1]);
        }
      },
      future: getExerciseData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: projectWidget(),
    );
  }
}

class ExerciseSearch extends Search {
  List<String> exerciseList;
  List<String> itemDescriptions;

  ExerciseSearch(List<String> _exerciseList, List<String> _itemDescriptions) {
    this.exerciseList = _exerciseList;
    this.itemDescriptions = _itemDescriptions;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar App',
      home: HomePage(exerciseList, itemDescriptions),
    );
  }
}
