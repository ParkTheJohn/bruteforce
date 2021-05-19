import 'package:cse_115a/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'chooseExercise.dart';
import 'main.dart';

enum SlidableAction { delete }

class currentPlanPage extends StatefulWidget {
  // This is used so that the Navigator in workoutPage.dart can send the name of
  // the plan the was clicked by the button onPressed()
  final String currentPlanName;
  currentPlanPage({Key key, @required this.currentPlanName}) : super(key: key);
  @override
  _editWorkouts createState() => _editWorkouts();
}

class _editWorkouts extends State<currentPlanPage> {
  Future<List<String>> _listFuture;
  List<String> exercises = [];
  List<String> exerciseDescriptions = [];
  @override
  void initState() {
    super.initState();

    _listFuture = getUserWorkoutPlans();
  }

  Future<List<String>> removeList(int index) async {
    exercises.removeAt(index);
    return exercises;
  }

  Future<List<String>> getUserWorkoutPlans() async {
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(currentUID)
        .collection('workoutPlans')
        .doc(widget.currentPlanName)
        .collection('Exercises')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (exercises.length == documents.length) return exercises;
    for (int i = 0; i < documents.length; i++) {
      exercises.add(documents[i]['Exercise Name']);
    }
    for (int i = 0; i < exercises.length; i++) {
      final DocumentSnapshot result = await FirebaseFirestore.instance
          .collection('Exercise_List')
          .doc(exercises[i])
          .get();
      if (result['description'] != null)
        exerciseDescriptions.add(result['description']);
    }
    return exercises;
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: getUserWorkoutPlans(),
      builder: (context, projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          print(projectSnap.data);
          if (projectSnap.data.length == 0)
            return Text("You currently have no exercises!");
          return Row(children: [
            Expanded(
                child: SizedBox(
                    height: 100000.0,
                    child: ListView.builder(
                      itemCount: projectSnap.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SlidableWidget(
                            child: Card(
                              child: ListTile(
                                title: Text(projectSnap.data[index]),
                                onTap: () => Scaffold.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text(exerciseDescriptions[index]))),
                              ),
                            ),
                            onDismissed: (action) {
                              dismissSlidableItem(context, index);
                            });
                        //);
                      },
                    )))
          ]);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.currentPlanName),
        ),
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Container(
              child: ElevatedButton(
                  child: Text('Add Exercises'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChooseExercise(
                                currentPlanName: widget.currentPlanName)));
                  })),
          Container(
            child: projectWidget(),
          ),
        ]));
  }

  void dismissSlidableItem(BuildContext context, int index) {
    FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('workoutPlans')
        .doc(widget.currentPlanName)
        .collection('Exercises')
        .doc(exercises[index])
        .delete();
    Utils.showSnackBar(
        context,
        exercises[index] +
            'has been removed from ' +
            widget.currentPlanName +
            '!');
    removeList(index);
    setState(() {
      getUserWorkoutPlans();
    });
  }
}

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    @required this.child,
    @required this.onDismissed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,

        /// right side
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.black45,
            icon: Icons.delete,
            onTap: () => onDismissed(SlidableAction.delete),
          ),
        ],
      );
}
