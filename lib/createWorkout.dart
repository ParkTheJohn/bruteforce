import 'package:flutter/material.dart';

/*
TODO: Create a button that would pull up a dialog/drawer that would display 
all the exercises similar to the exercises page. On press, add the exercise to
the list and display it in the createWorkout Listview. Add a 'save workout'
button to save the workout and store it in 
the database (userinfo/currentUID/workoutplans).
*/

class createWorkoutPage extends StatelessWidget {
  final TextEditingController planNameController = TextEditingController();
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
      ]),
    );
  }
}
