import 'package:cse_115a/chooseExercise.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'searchBar.dart';

class exercisesPage extends StatefulWidget {
  exercisesPage2 createState() => exercisesPage2();
}

class exercisesPage2 extends State<exercisesPage> {
  List<List<String>> exercises = [];
  Future<void> getExerciseData() async {
    //if (exercises.length != 0) return exercises;
    List<String> exerciseNames = [];
    List<String> exerciseDescription = [];
    List<String> exerciseCategory = [];
    List<String> exerciseEquipment = [];

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
      exerciseDescription.add(customDoc[i]['description']);
      exerciseCategory.add("");
      exerciseEquipment.add("");
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
      exerciseDescription.add(documents[i]['description']);
      exerciseCategory.add(documents[i]['category']['name']);
      if (documents[i]['equipment'].length > 1)
        exerciseEquipment.add(documents[i]['equipment'][0]['name']);
    }

    await exercises.add(exerciseNames);
    await exercises.add(exerciseDescription);
    await exercises.add(exerciseCategory);
    await exercises.add(exerciseEquipment);

    return exercises;
  }

  void refresh() {
    setState(() {
      getExerciseData();
    });
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          getExerciseData();
          return Center(child: CircularProgressIndicator());
        }

        var temp = exercises;
        exercises = [];
        return SearchBar(searchableList: temp);
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

