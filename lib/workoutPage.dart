import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'LoginService.dart';
import 'createWorkout.dart';

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
      print('added ${workoutPlans[i]}');
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
          print("workoutPlans.length ${projectSnap.data.length}");
          if (projectSnap.data.length == 0)
            return Text("You currently have no plans");
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(projectSnap.data[index]),
                  // onTap: () => Scaffold.of(context).showSnackBar(
                  //     SnackBar(content: Text(exercises[1][index]))),
                ),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(8), children: <Widget>[
      Container(
        child: projectWidget(),
      ),
      Container(
          child: ElevatedButton(
              child: Text('Open route'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => createWorkoutPage()),
                );
              })),
    ]);
  }
}
