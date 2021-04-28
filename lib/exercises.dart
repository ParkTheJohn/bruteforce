//library pages;

//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class exercisesPage extends StatelessWidget {
  List<List<String>> exercises = [];
  List<String> exerciseNames = [];
  List<String> exerciseDescription = [];
  Future<void> getExerciseData() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Exercises').get();
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
    }
    for (int i = 0; i < documents.length; i++) {
      exerciseDescription.add(documents[i]['description']);
    }
    exercises.add(exerciseNames);
    exercises.add(exerciseDescription);

    return exercises;
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          print('project snapshot data is: ${projectSnap.data[0]}');

          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              //ProjectModel project = projectSnap.data[index];
              return Card(
                child: ListTile(
                  title: Text(projectSnap.data[0][index]),
                  onTap: () => Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(content: Text(projectSnap.data[1][index]))),
                ),
                // color: Colors.amber[100],
                // child: Center(child: Text(projectSnap.data[index])),
              );
            },
          );
        }
      },
      future: getExerciseData(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: projectWidget(),
    );
  }
}
