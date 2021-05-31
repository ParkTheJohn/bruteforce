import 'package:cse_115a/startWorkoutPlan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class startWorkoutPage extends StatelessWidget {
  var plansCount = 0;
  List<String> plans;
  Future<List<String>> getUserWorkoutPlans() async {
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    List<String> workoutPlans = [];
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(currentUID)
        .collection('workoutPlans')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    plansCount = documents.length;
    for (int i = 0; i < documents.length; i++) {
      workoutPlans.add(documents[i]['name']);
    }
    plans = workoutPlans;
    return workoutPlans;
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: getUserWorkoutPlans(),
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          if (projectSnap.data.length == 0)
            return Text("You currently have no plans");
          return Row(children: [
            Expanded(
              child: SizedBox(
                height: 100000.0,
                child: new ListView.builder(
                  itemCount: projectSnap.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        title: Text(projectSnap.data[index]),
                        onTap: () =>
                            navigatePlanPage(context, projectSnap.data[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
          ]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Container(
          child: ElevatedButton(
              child: Text('Select a Random Workout!'),
              onPressed: () {
                if (plansCount != 0) {
                  navigatePlanPage(
                      context, plans[Random().nextInt(plansCount)]);
                }
              })),
      Container(
        child: projectWidget(),
      ),
    ]);
  }
}

// Changes the current screen to a new screen displaying the name of the workout
// plan that was pressed and it's exercises.
void navigatePlanPage(BuildContext context, String data) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => startWorkoutPlan(currentWorkout: data)),
  );
}
