import 'package:cse_115a/main.dart';
import 'package:cse_115a/slidable_widget.dart';
import 'package:cse_115a/utils.dart';
import 'package:cse_115a/workoutPage.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:uuid/uuid.dart';

class CustomWorkoutExercise extends StatelessWidget {
  final TextEditingController exerciseNameController = TextEditingController();
  final TextEditingController exerciseField1 = TextEditingController();
  var uuid = Uuid();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Custom Exercise"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        Container(
          child: TextField(
            controller: exerciseNameController,
            decoration: InputDecoration(
              labelText: "Enter Exercise Name",
              //errorText: _validate ? 'Value Can\'t Be Empty' : null,
            ),
          ),
        ),
        Container(
          child: TextField(
            controller: exerciseField1,
            decoration: InputDecoration(
              labelText: "Enter Body Part",
            ),
          ),
        ),
        Container(
            child: ElevatedButton(
                child: Text('Create'),
                onPressed: () {
                  print(exerciseNameController.text);
                  print(exerciseField1.text);
                  //myPlanName = planNameController.text;
                  FirebaseFirestore.instance
                      .collection('UserInfo')
                      .doc(getFirebaseUser)
                      .collection('customExercises')
                      .doc(exerciseNameController.text)
                      .set({
                    "id": -1,
                    "name": exerciseNameController.text,
                    "uuid": uuid.v4(),
                    "description": "Temp Description",
                    "creation_date": DateTime.now(),
                    "category": {"id": -1, "name": exerciseField1.text},
                    "muscles": [],
                    "muscles_secondary": [],
                    "equipment": [
                      {"id": -1, "name": "N/A"}
                    ],
                    "language": {
                      "id": 2,
                      "short_name": "en",
                      "full_name": "English"
                    },
                    "license": {
                      "id": 2,
                      "full_name": "User Name",
                      "short_name": "N/A",
                      "url": "N/A"
                    },
                    "license_author": "User Name",
                    "images": [],
                    "comments": [],
                    "variations": []
                  });
                  FirebaseFirestore.instance
                      .collection('UserInfo')
                      .doc(getFirebaseUser)
                      .collection('workoutPlans')
                      .doc(getNewPlanName)
                      .collection('Exercises')
                      .doc(exerciseNameController.text)
                      .set({'Exercise Name': exerciseNameController.text});
                  // Utils.showSnackBar(
                  //     context,
                  //     exerciseNameController.text +
                  //         'has been added to ' +
                  //         getNewPlanName +
                  //         '!');
                  // FirebaseFirestore.instance
                  //     .collection('UserInfo')
                  //     .doc(getFirebaseUser)
                  //     .collection('workoutPlans')
                  //     .doc(planNameController.text)
                  //     .collection('Exercises');
                  Navigator.pop(context);
                })),
      ]),
    );
  }
}
