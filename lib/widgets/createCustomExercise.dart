import 'package:cse_115a/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class CustomWorkoutExercise extends StatelessWidget {
  final String currentPlanName;
  CustomWorkoutExercise({Key key, @required this.currentPlanName})
      : super(key: key);

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
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('UserInfo')
                      .doc(getFirebaseUser)
                      .collection('customExercises')
                      .doc(exerciseNameController.text)
                      .set({
                    "id": -1,
                    "name": exerciseNameController.text,
                    "uuid": uuid.v4(),
                    "description": "Custom Exercise",
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
                  await FirebaseFirestore.instance
                      .collection('UserInfo')
                      .doc(getFirebaseUser)
                      .collection('workoutPlans')
                      .doc(currentPlanName)
                      .collection('Exercises')
                      .doc(exerciseNameController.text)
                      .set({
                    'Exercise Name': exerciseNameController.text,
                    'Exercise Data': [
                      {"reps": 0, "sets": 0, "weight": 0, "finished": 0}
                    ],
                    'Finished': false,
                  });
                  Navigator.pop(context);
                })),
      ]),
    );
  }
}
