import 'package:cse_115a/chooseExercise.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:cse_115a/main.dart';
import 'package:cse_115a/slidable_widget.dart';
import 'package:cse_115a/utils.dart';
import 'package:cse_115a/workoutPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class startWorkoutPlan extends StatefulWidget {
  final String currentWorkout;
  startWorkoutPlan({Key key, @required this.currentWorkout}) : super(key: key);
  @override
  _startWorkoutPlan createState() => _startWorkoutPlan();
}

class _startWorkoutPlan extends State<startWorkoutPlan> {
  @override
  Future<List<List>> _listFuture;
  var textbox = 0;
  List<List> sol = [];
  //String currentWorkout;
  //_startWorkoutPlan({Key key, @required this.currentWorkout}) : super(key: key);

  List<TextEditingController> _sets = [
    for (int i = 1; i < 75; i++) TextEditingController()
  ];

  List<TextEditingController> _reps = [
    for (int i = 1; i < 75; i++) TextEditingController()
  ];

  List<TextEditingController> _weight = [
    for (int i = 1; i < 75; i++) TextEditingController()
  ];

  @override
  void initState() {
    super.initState();

    _listFuture = getUserWorkoutPlans();
  }

  void refreshList(int index, String action) {
    if (action == "add") {
      setState(() {
        _listFuture = addList(index);
      });
    } else if (action == "remove") {
      setState(() {
        _listFuture = removeList(index);
      });
    }
  }

  Future<List<List>> removeList(int index) async {
    sol[0].removeAt(index);
    sol[1].removeAt(index);
    textbox--;
    _sets.removeAt(index);
    _reps.removeAt(index);
    _weight.removeAt(index);

    return sol;
  }

  Future<List<List>> addList(int index) async {
    //print(sol[0]);
    sol[0].insert(index + 1, sol[0][index]);
    sol[1].insert(index + 1, [0, 0, 0]);
    _sets.insert(index + 1, TextEditingController());
    _reps.insert(index + 1, TextEditingController());
    _weight.insert(index + 1, TextEditingController());
    textbox++;
    _sets[index + 1].text = sol[1][index + 1][0].toString();
    _reps[index + 1].text = sol[1][index + 1][1].toString();
    _weight[index + 1].text = sol[1][index + 1][2].toString();

    //print(sol);
    return sol;
  }

  Future<List<List>> getUserWorkoutPlans() async {
    print(widget.currentWorkout);
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    List<String> workoutPlans = [];
    List<List> workoutData = [];
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(currentUID)
        .collection('workoutPlans')
        .doc(widget.currentWorkout)
        .collection('Exercises')
        .get();
    debugPrint("WORKOUT PLAN IS: " + widget.currentWorkout);
    var list = result.docs;
    final List<DocumentSnapshot> documents = result.docs;
    //debugPrint(list.toString());
    debugPrint(
        "Number of exercises in plan is: " + documents.length.toString());
    //debugPrint(documents[0]['Exercise Name']);
    print(documents.length);
    for (int i = 0; i < documents.length; i++) {
      for (int j = 0; j < documents[i]["Exercise Data"].length; j++) {
        workoutPlans.add(documents[i]['Exercise Name']);
        workoutData.add([
          documents[i]["Exercise Data"][j]["reps"],
          documents[i]["Exercise Data"][j]["sets"],
          documents[i]["Exercise Data"][j]["weight"]
        ]);
        print("The reps are: " +
            documents[i]["Exercise Data"][j]["reps"].toString());
        _sets[textbox].text =
            documents[i]["Exercise Data"][j]["sets"].toString();
        _reps[textbox].text =
            documents[i]["Exercise Data"][j]["reps"].toString();
        _weight[textbox].text =
            documents[i]["Exercise Data"][j]["weight"].toString();
        textbox++;
      }

      //debugPrint(documents[0]['Exercise Name']);
    }
    //debugPrint(documents[0]['Exercise Name']);

    // FirebaseFirestore.instance
    //     .collection('UserInfo')
    //     .doc(currentUID)
    //     .collection('workoutPlans')
    //     .doc(currentWorkout)
    //     .collection('Exercises')
    //     .doc('custom')
    //     .update({
    //   'Exercise Data': [
    //     {"reps": 0, "sets": 1, "weight": 1}
    //   ]
    // });

    // debugPrint("exercise data: " + documents[0]["Exercise Data"][0].toString());
    // await FirebaseFirestore.instance
    //     .collection('UserInfo')
    //     .doc(currentUID)
    //     .collection('workoutPlans')
    //     .doc(currentWorkout)
    //     .collection('Exercises')
    //     .doc(documents[0]["Exercise Name"])
    //     .update({
    //   'Exercise Data': FieldValue.arrayUnion([
    //     {"reps": 6, "sets": 9, "weight": 100}
    //   ])
    // });
    // debugPrint(
    //     "exercise data 2 : " + documents[0]["Exercise Data"][1].toString());
    sol.add(workoutPlans);
    sol.add(workoutData);
    return sol;
  }

  Widget projectWidget() {
    return new FutureBuilder<List<List>>(
      future: _listFuture,
      builder: (BuildContext context, AsyncSnapshot<List<List>> projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          //print("workoutPlans.length ${projectSnap.data.length}");
          if (projectSnap.data[0].length == 0)
            return Text("You currently have no exercises!");
          // debugPrint("Exercises: ${projectSnap.data.length}");
          return Row(children: [
            Expanded(
              child: SizedBox(
                height: 100000.0,
                child: new ListView.builder(
                  itemCount: projectSnap.data[0].length,
                  itemBuilder: (BuildContext context, int index) {
                    return SlidableWidget(
                      child: Card(
                          child: Column(children: <Widget>[
                        ListTile(
                          title: Text(projectSnap.data[0][index]),
                          trailing: Icon(Icons.check),
                          onTap: () => Utils.showSnackBar(
                              context,
                              'Exercise ' +
                                  projectSnap.data[0][index] +
                                  ' has been finished'),
                        ),
                        //new Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //children: <Widget>[
                        Row(children: <Widget>[
                          new Flexible(
                              child: TextFormField(
                            controller: _sets[index],
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter sets'),
                          )),
                          new Flexible(
                              child: TextFormField(
                            controller: _reps[index],
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter reps'),
                          )),
                          new Flexible(
                              child: TextFormField(
                            controller: _weight[index],
                            decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Enter Weight'),
                          )),
                        ]),

                        //]),

                        Row(
                          children: <Widget>[
                            TextButton(
                                child: Text("New Set"),
                                onPressed: () {
                                  refreshList(index, "add");
                                }),
                            TextButton(
                              child: const Text('Print'),
                              onPressed: () {
                                print(_sets[index].text);
                                print(_reps[index].text);
                                print(_weight[index].text);
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                refreshList(index, "remove");
                              },
                            ),
                          ],
                        ),
                      ])
                          // child: ListTile(
                          //   title: Text(projectSnap.data[index]),
                          //   onTap: () => debugPrint(
                          //       "Clicking ${projectSnap.data[index]} box"),
                          // ),
                          ),
                      onDismissed: (action) =>
                          dismissSlidableItem(context, index, action),
                    );
                  },
                ),
              ),
            ),
            //Text(Test)
          ]);
        }
      },
    );
  }

  void dismissSlidableItem(
      BuildContext context, int index, SlidableAction action) {
    setState(() {
      //exercises.removeAt([0][index]);
    });

    switch (action) {
      // case SlidableAction.archive:
      //   Utils.showSnackBar(context, 'Chat has been archived');
      //   break;
      // case SlidableAction.share:
      //   Utils.showSnackBar(context, 'Chat has been shared');
      //   break;
      case SlidableAction.delete:
        print("Assuming this is delete button for now");
        refreshList(index, "remove");
        //Utils.showSnackBar(context, 'Selected more');
        break;
      case SlidableAction.add:
        //Utils.showSnackBar(context, 'pressed add');
        refreshList(index, "add");
        break;
    }
  }

  void saveToExercise() {
    //print(sol);
    for (int i = 0; i < sol[0].length; i++) {
      if (i == 0 || sol[0][i] != sol[0][i - 1]) {
        FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(widget.currentWorkout)
            .collection('Exercises')
            .doc(sol[0][i])
            .set(
          {
            'Exercise Name': sol[0][i],
            'Exercise Data': FieldValue.arrayUnion([
              {
                "reps": int.parse(_reps[i].text),
                "sets": int.parse(_sets[i].text),
                "weight": int.parse(_weight[i].text)
              }
            ])
          },
        );
      } else {
        FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(widget.currentWorkout)
            .collection('Exercises')
            .doc(sol[0][i])
            .update({
          'Exercise Data': FieldValue.arrayUnion([
            {
              "reps": int.parse(_reps[i].text),
              "sets": int.parse(_sets[i].text),
              "weight": int.parse(_weight[i].text)
            }
          ])
        });
      }
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PLAN: " + widget.currentWorkout),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  saveToExercise();
                },
                child: Text(
                  'Finish',
                  style: TextStyle(
                      fontFamily: 'Futura',
                      fontSize: 15,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                )),
          ],
        ),
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Container(),
          Container(
            child: ElevatedButton(
                child: Text('Add new Exercise'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChooseExercise()),
                  );
                }),
          ),
          Container(
            child: projectWidget(),
          ),
        ]));
  }

  void addExercise() {
    //setNewPlanName(currentWorkout);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChooseExercise()),
    );
  }
}