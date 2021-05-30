import 'package:cse_115a/createCustomExercise.dart';
import 'package:cse_115a/main.dart';
import 'package:cse_115a/slidable_widget.dart';
import 'package:cse_115a/utils.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ChooseExercise extends StatefulWidget {
  final String currentPlanName;
  ChooseExercise({Key key, @required this.currentPlanName}) : super(key: key);
  ExercisePage createState() => ExercisePage();
}

List<List> exerciseListChooseExercise = [];
Future<List<List>> futureExercisesList;
String exercise = "nullChooseExercise";

class ExercisePage extends State<ChooseExercise> {
  Future<List<List>> getExerciseData() async {
    exerciseListChooseExercise = [];
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
    for (int i = 0; i < customDoc.length; i++) {
      exerciseNames.add(customDoc[i]['name']);
      exerciseDescription.add(customDoc[i]['description']);
      exerciseCategory.add(customDoc[i]['category']['name']);
    }

    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
      exerciseDescription.add(documents[i]['description']);
      exerciseCategory.add(documents[i]['category']['name']);
    }

    exerciseListChooseExercise.add(exerciseNames);
    exerciseListChooseExercise.add(exerciseDescription);
    exerciseListChooseExercise.add(exerciseCategory);
    return exerciseListChooseExercise;
  }

  void refresh() {
    setState(() {
      futureExercisesList = getExerciseData();
    });
  }

  @override
  void initState() {
    super.initState();
    if (futureExercisesList == null) {
      futureExercisesList = getExerciseData();
    }
  }

  Widget projectWidget() {
    return new FutureBuilder<List<List>>(
      future: futureExercisesList,
      builder: (BuildContext context, AsyncSnapshot<List<List>> projectSnap) {
        if (!projectSnap.hasData) {
          return Text("Loading...");
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
            },
          );
        }
      },
    );
  }

  void dismissSlidableItem(
      BuildContext context, int index, SlidableAction action) {
    setState(() {});

    var nameOfExerciseClicked = FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('workoutPlans')
        .doc(widget.currentPlanName)
        .collection('Exercises')
        .doc(exerciseListChooseExercise[0][index]);

    switch (action) {
      case SlidableAction.delete:
        nameOfExerciseClicked.delete();
        Utils.showSnackBar(
            context,
            exerciseListChooseExercise[0][index] +
                ' has been removed from ' +
                widget.currentPlanName +
                '!');
        break;
      case SlidableAction.add:
        nameOfExerciseClicked.set({
          'Exercise Name': exerciseListChooseExercise[0][index],
          'Exercise Data': [
            {"reps": 0, "sets": 0, "weight": 0, "finished": 0}
          ],
          'Finished': false,
        });
        Utils.showSnackBar(
            context,
            exerciseListChooseExercise[0][index] +
                ' has been added to ' +
                widget.currentPlanName +
                ' !');
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomWorkoutExercise(
                    currentPlanName: widget.currentPlanName)),
          ).then((value) => refresh());
        },
        label: const Text('Create'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

String get getExercise {
  return exercise;
}
