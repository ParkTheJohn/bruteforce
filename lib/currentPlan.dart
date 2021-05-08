import 'dart:ffi';

import 'package:cse_115a/workoutPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class currentPlanPage extends StatelessWidget {
  // This is used so that the Navigator in workoutPage.dart can send the name of
  // the plan the was clicked by the button onPressed()
  final String currentPlanName;
  currentPlanPage({Key key, @required this.currentPlanName}) : super(key: key);

  Future<List<String>> getUserWorkoutPlans() async {
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    List<String> workoutPlans = [];
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(currentUID)
        .collection('workoutPlans')
        .doc(currentPlanName)
        .collection('Exercises')
        .get();
    debugPrint("WORKOUT PLAN IS: " + currentPlanName);
    var list = result.docs;
    final List<DocumentSnapshot> documents = result.docs;
    debugPrint(list.toString());
    debugPrint(
        "Number of exercises in plan is: " + documents.length.toString());
    debugPrint(documents[0]['Exercise Name']);
    for (int i = 0; i < documents.length; i++) {
      workoutPlans.add(documents[i]['Exercise Name']);
      debugPrint(documents[0]['Exercise Name']);
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
            return Text("You currently have no exercises!");
          debugPrint("Exercises: ${projectSnap.data.length}");
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
                        onTap: () => debugPrint(
                            "Clicking ${projectSnap.data[index]} box"),
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
    return Scaffold(
        appBar: AppBar(
          title: Text(currentPlanName),
        ),
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Container(
              child: ElevatedButton(
                  child: Text('Test'),
                  onPressed: () {
                    Text("Hi");
                  })),
          // Container(
          //   child: ElevatedButton(child: Text('Plan 1'), onPressed: () {}),
          // ),
          Container(
            child: projectWidget(),
          ),
        ]));
  }
}
