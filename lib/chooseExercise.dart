//library pages;

import 'package:cse_115a/createCustomExercise.dart';
import 'package:cse_115a/main.dart';
import 'package:cse_115a/slidable_widget.dart';
import 'package:cse_115a/utils.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChooseExercise extends StatefulWidget {
  final String currentPlanName;
  ChooseExercise({Key key, @required this.currentPlanName}) : super(key: key);
  ExercisePage createState() => ExercisePage();
}

List<List> exerciseList_ChooseExercise = [];
Future<List<List>> exercises;
String exercise = "nullChooseExercise";

class ExercisePage extends State<ChooseExercise> {
  Future<List<List>> getExerciseData() async {
    exerciseList_ChooseExercise = [];
    //if (exercises.length != 0) return exercises;
    List<String> exerciseNames = [];
    List<String> exerciseDescription = [];
    List<String> exerciseCategory = [];
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Exercise_List').get();
    final List<DocumentSnapshot> documents = result.docs;

    final QuerySnapshot result2 = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('customExercises')
        .get();
    final List<DocumentSnapshot> customDoc = result2.docs;

    //debugPrint(customDoc[0].get('category'));
    for (int i = 0; i < customDoc.length; i++) {
      exerciseNames.add(customDoc[i]['name']);
    }
    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
    }
    // for (int i = 0; i < customDoc.length; i++) {
    //   exerciseDescription.add("Just testing names");
    // }

    for (int i = 0; i < customDoc.length; i++) {
      exerciseDescription.add(customDoc[i]['description']);
    }

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

    exerciseList_ChooseExercise.add(exerciseNames);
    exerciseList_ChooseExercise.add(exerciseDescription);
    exerciseList_ChooseExercise.add(exerciseCategory);

    return exerciseList_ChooseExercise;
  }

  void refresh() {
    setState(() {
      exercises = getExerciseData();
    });
  }

  @override
  void initState() {
    super.initState();
    print("init state");
    if (exercises == null) {
      print("Reloading state");
      exercises = getExerciseData();
    }
    //_sets[0].addListener(saveToExercise);
  }

  Widget projectWidget() {
    print("This is currentPlanName: " + widget.currentPlanName);
    return new FutureBuilder<List<List>>(
      future: exercises,
      builder: (BuildContext context, AsyncSnapshot<List<List>> projectSnap) {
        if (!projectSnap.hasData) {
          return Text("Something wrong");
        } else {
          return ListView.builder(
            itemCount: projectSnap.data[0].length,
            itemBuilder: (context, index) {
              exercise = projectSnap.data[0][index];

              return SlidableWidget(
                child: Card(
                  child: ListTile(
                    title: Text(projectSnap.data[0][index]),
                    onTap: () => Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(projectSnap.data[1][index]))),
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
    );
  }

  void dismissSlidableItem(
      BuildContext context, int index, SlidableAction action) {
    setState(() {
      //exercises.removeAt([0][index]);
    });

    switch (action) {
      case SlidableAction.delete:
        FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(widget.currentPlanName)
            .collection('Exercises')
            .doc(exerciseList_ChooseExercise[0][index])
            .delete();
        Utils.showSnackBar(
            context,
            exerciseList_ChooseExercise[0][index] +
                'has been removed from ' +
                widget.currentPlanName +
                '!');
        break;
      case SlidableAction.add:
        print(exerciseList_ChooseExercise[0][index]);
        print(widget.currentPlanName);
        print(getFirebaseUser);
        FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(widget.currentPlanName)
            .collection('Exercises')
            .doc(exerciseList_ChooseExercise[0][index])
            .set({
          'Exercise Name': exerciseList_ChooseExercise[0][index],
          'Exercise Data': [
            {"reps": 0, "sets": 0, "weight": 0, "finished": 0}
          ],
          'Finished': false,
        });
        Utils.showSnackBar(
            context,
            exerciseList_ChooseExercise[0][index] +
                'has been added to ' +
                widget.currentPlanName +
                ' !');
        break;
      // case SlidableAction.details:
      //   print('pressed details');
      //   break;
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
            MaterialPageRoute(
                builder: (context) => CustomWorkoutExercise(
                    currentPlanName: widget.currentPlanName)),
          ).then((value) => refresh());
        },
        tooltip: 'Create a custom Exercise',
        child: const Icon(Icons.add),
      ),
    );
  }
}

String get getExercise {
  return exercise;
}
