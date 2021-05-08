import 'package:cse_115a/currentPlan.dart';
import 'package:cse_115a/startWorkoutPlan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'LoginService.dart';
import 'createWorkout.dart';
import 'currentPlan.dart';

//String myplan = "null2";

class startWorkoutPage extends StatelessWidget {
  Future<List<String>> getUserWorkoutPlans() async {
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    List<String> workoutPlans = [];
    print("This is currentUID: ${currentUID}");
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(currentUID)
        .collection('workoutPlans')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      workoutPlans.add(documents[i]['name']);
      debugPrint('added ${workoutPlans[i]}');
    }
    return workoutPlans;
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: getUserWorkoutPlans(),
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          //print("workoutPlans.length ${projectSnap.data.length}");
          if (projectSnap.data.length == 0)
            return Text("You currently have no plans");
          debugPrint("Plans: ${projectSnap.data.length}");
          return Row(children: [
            Expanded(
              child: SizedBox(
                height: 100000.0,
                child: new ListView.builder(
                  itemCount: projectSnap.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
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
                print("Need to add functionality");
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
