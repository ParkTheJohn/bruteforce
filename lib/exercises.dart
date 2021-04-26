library pages;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class exercisesPage extends StatelessWidget {
  List<String> exerciseNames = List();
  Future<void> getExerciseData() async {
    final QuerySnapshot result =
        await FirebaseFirestore.instance.collection('Exercises').get();
    final List<DocumentSnapshot> documents = result.docs;
    List<String> exerciseNames = List();
    for (int i = 0; i < documents.length; i++) {
      exerciseNames.add(documents[i]['name']);
    }

    // exercise = documents[currentExer]['name'];
    return exerciseNames;
  }

  Widget projectWidget() {
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          //print('project snapshot data is: ${projectSnap.data}');
          return ListView.builder(
            itemCount: projectSnap.data.length,
            itemBuilder: (context, index) {
              //ProjectModel project = projectSnap.data[index];
              return Column(
                children: <Widget>[
                  Text(projectSnap.data[index]),
                ],
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
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: projectWidget(),
    );
  }
}
