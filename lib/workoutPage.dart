import 'package:cse_115a/currentPlan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'LoginService.dart';
import 'createWorkout.dart';

String myplan = "null2";

class workoutPage extends StatelessWidget {
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
              child: Text('Create Plan'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => createWorkoutPage()),
                );
              })),
      // Container(
      //   child: ElevatedButton(child: Text('Plan 1'), onPressed: () {}),
      // ),
      Container(
        child: projectWidget(),
      ),
    ]);
  }
}

String get getWorkoutPlan {
  debugPrint("getWorkoutPlan name...." + myplan);
  return myplan;
}

set setWorkoutPlan(String data) {
  myplan = data;
  debugPrint("setWorkoutPlan+++" + getWorkoutPlan);
}

void navigatePlanPage(BuildContext context, String data) {
  setWorkoutPlan = data;
  debugPrint("THE PLAN NAME IN WORKOUTPAGE IS: " + data);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => currentPlanPage()),
  );
}
