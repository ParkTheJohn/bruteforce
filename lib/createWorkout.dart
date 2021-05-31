import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_115a/chooseExercise.dart';
import 'package:cse_115a/main.dart';
import 'package:flutter/material.dart';

class createWorkoutPage extends StatelessWidget {
  final TextEditingController planNameController = TextEditingController();
  bool _validate = false;
  @override
  List<String> exercises;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create a Workout"),
      ),
      body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
        Container(
          child: TextField(
            controller: planNameController,
            decoration: InputDecoration(
              labelText: "Enter Plan Name",
            ),
          ),
        ),
        Container(
            child: ElevatedButton(
                child: Text('Add Exercises'),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('UserInfo')
                      .doc(getFirebaseUser)
                      .collection('workoutPlans')
                      .doc(planNameController.text)
                      .set({'name': planNameController.text});
                  FirebaseFirestore.instance
                      .collection('UserInfo')
                      .doc(getFirebaseUser)
                      .collection('workoutPlans')
                      .doc(planNameController.text)
                      .collection('Exercises');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseExercise(
                              currentPlanName: planNameController.text)));
                })),
      ]),
    );
  }
}
