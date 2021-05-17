//library pages;

import 'package:cse_115a/createCustomExercise.dart';
import 'package:cse_115a/main.dart';
import 'package:cse_115a/slidable_widget.dart';
import 'package:cse_115a/utils.dart';
import 'package:cse_115a/workoutPage.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ChooseExercise extends StatefulWidget {
  ExercisePage createState() => ExercisePage();
}

String exercise = "test";

class ExercisePage extends State<ChooseExercise> {
  List<List<String>> exercises = [];
  Future<void> getExerciseData() async {
    if (exercises.length != 0) return exercises;
    List<String> exerciseNames = [];
    List<String> exerciseDescription = [];
    List<String> exerciseCategory = [];
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Exercises').get();
    final List<DocumentSnapshot> documents = result.docs;

    final QuerySnapshot result2 = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('customExercises')
        .get();
    final List<DocumentSnapshot> customDoc = result2.docs;

    //debugPrint(customDoc[0].get('category'));
    for (int i = 0; i < customDoc.length; i++) {
      exerciseNames.add("temp" + i.toString());
    }
    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
    }
    // for (int i = 0; i < customDoc.length; i++) {
    //   exerciseDescription.add("Just testing names");
    // }
    for (int i = 0; i < documents.length; i++) {
      exerciseDescription.add(documents[i]['description']);
    }

    debugPrint(customDoc[0]['category']['name']);

    for (int i = 0; i < customDoc.length; i++) {
      exerciseCategory.add(customDoc[i]['category']['name']);
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseCategory.add(documents[i]['category']['name']);
    }

    exercises.add(exerciseNames);
    exercises.add(exerciseDescription);
    exercises.add(exerciseCategory);

    return exercises;
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          return ListView.builder(
            itemCount: exercises[0].length,
            itemBuilder: (context, index) {
              exercise = exercises[0][index];

              return SlidableWidget(
                child: Card(
                  child: ListTile(
                    title: Text(exercises[0][index]),
                    onTap: () => Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(exercises[1][index]))),
                  ),
                ),
                onDismissed: (action) =>
                    dismissSlidableItem(context, index, action),
              );
              //);
            },
          );
        }
      },
      future: getExerciseData(),
    );
  }

  void dismissSlidableItem(
      BuildContext context, int index, SlidableAction action) {
    setState(() {
      //exercises.removeAt([0][index]);
    });

    switch (action) {
      // case SlidableAction.archive:
      //   Utils.showSnackBar(context, 'Chat has been archived');
      //   break;
      // case SlidableAction.share:
      //   Utils.showSnackBar(context, 'Chat has been shared');
      //   break;
      case SlidableAction.more:
        Utils.showSnackBar(context, 'Selected more');
        break;
      case SlidableAction.add:
        print(exercises[0][index]);
        print(getNewPlanName);
        print(getFirebaseUser);
        FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(getNewPlanName)
            .collection('Exercises')
            .doc(exercises[0][index])
            .set({'Exercise Name': exercises[0][index]});
        Utils.showSnackBar(context,
            exercises[0][index] + 'has been added to ' + getNewPlanName + ' !');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Add a Workout"),
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Icon(
                Icons.close,
              ))),
      body: projectWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CustomWorkoutExercise()),
          );
        },
        tooltip: 'Increment Counter',
        child: const Icon(Icons.add),
      ),
    );
  }
}

String get getExercise {
  return exercise;
}
