import 'package:cse_115a/currentPlan.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'createWorkout.dart';
import 'currentPlan.dart';
import 'utils.dart';

enum _SlidableAction { delete }

class workoutPage extends StatefulWidget {
  String currentUID = FirebaseAuth.instance.currentUser.uid;
  _workoutPage createState() => _workoutPage();
}

class _workoutPage extends State<workoutPage> {
  Future<List<String>> _listFuture;
  List<String> workoutPlans = [];

  @override
  void initState() {
    super.initState();

    _listFuture = getUserWorkoutPlans();
  }

  Future<List<String>> removeList(int index) async {
    workoutPlans.removeAt(index);
    return workoutPlans;
  }

  Future<List<String>> getUserWorkoutPlans() async {
    List<String> workoutPlans = [];
    print("This is currentUID: ${widget.currentUID}");
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(widget.currentUID)
        .collection('workoutPlans')
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (result.docs.length == workoutPlans.length) return workoutPlans;
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
                        return _SlidableWidget(
                            child: Card(
                              child: ListTile(
                                title: Text(projectSnap.data[index]),
                                onTap: () => navigatePlanPage(
                                    context, projectSnap.data[index]),
                              ),
                            ),
                            onDismissed: (action) {
                              print(index);
                              dismissSlidableItem(
                                  context, index, projectSnap.data[index]);
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
      Container(
        child: projectWidget(),
      ),
    ]);
  }

  void dismissSlidableItem(BuildContext context, int index, String name) {
    // print(workoutPlans[index]);
    FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('workoutPlans')
        .doc(name)
        .delete();
    Utils.showSnackBar(context, name + ' has been removed from workout plans!');
    removeList(index);
    setState(() {
      getUserWorkoutPlans();
    });
  }
}

class _SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(_SlidableAction action) onDismissed;

  const _SlidableWidget({
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
            onTap: () => onDismissed(_SlidableAction.delete),
          ),
        ],
      );
}

// Changes the current screen to a new screen displaying the name of the workout
// plan that was pressed and it's exercises.
void navigatePlanPage(BuildContext context, String data) {
  Navigator.push(
    context,
    MaterialPageRoute(
        builder: (context) => currentPlanPage(currentPlanName: data)),
  );
}
