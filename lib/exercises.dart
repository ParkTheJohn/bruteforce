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
    List<String> exerciseCategory = [];

    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Exercise_List').get();
    final List<DocumentSnapshot> documents = result.docs;

    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseDescription.add(documents[i]['description']);
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseCategory.add(documents[i]['category']['name']);
    }

    await exercises.add(exerciseNames);
    await exercises.add(exerciseDescription);
    await exercises.add(exerciseCategory);

    return exercises;
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          return ExerciseSearch(exercises);
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
  List<List<String>> exerciseList;

  ExerciseSearch(List<List<String>> _exerciseList) {
    this.exerciseList = _exerciseList;
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search Bar App',
      home: HomePage(exerciseList),
    );
  }
}
