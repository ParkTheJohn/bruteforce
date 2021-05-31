import 'package:cse_115a/chooseExercise.dart';
import 'package:cse_115a/main.dart';
import 'package:cse_115a/slidable_widget.dart';
import 'package:cse_115a/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

class startWorkoutPlan extends StatefulWidget {
  final String currentWorkout;
  startWorkoutPlan({Key key, @required this.currentWorkout}) : super(key: key);
  @override
  _startWorkoutPlan createState() => _startWorkoutPlan();
}

class _startWorkoutPlan extends State<startWorkoutPlan> {
  @override
  Future<List<List>> _listFuture;
  var tempVar = 6;
  var textbox = 0;
  List<List> sol = [];
  var uuid = Uuid();
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
      saveToExercise();
    } else if (action == "remove") {
      setState(() {
        _listFuture = removeList(index);
      });
      saveToExercise();
    } else if (action == "finish") {
      setState(() {
        _listFuture = finishedExercise(index);
      });
      saveToExercise();
    } else if (action == "reset") {
      resetProgress();
      setState(() {
        _listFuture = getUserWorkoutPlans();
      });
    }
  }

  Future<void> completedExercise(int index) async {
    final snapShot = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('ExerciseInfo')
        .doc(sol[0][index])
        .get();

    if (snapShot == null || !snapShot.exists) {

      FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(getFirebaseUser)
          .collection('ExerciseInfo')
          .doc(sol[0][index])
          .set({
        "name":sol[0][index].toString(),
      });


      FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(getFirebaseUser)
          .collection('ExerciseInfo')
          .doc(sol[0][index])
          .collection("Details")
          .doc(uuid.v1().toString())
          .set({
        "time": DateTime.now(),
        "reps": int.parse(_reps[index].text),
        "sets": int.parse(_sets[index].text),
        "weight": int.parse(_weight[index].text),
      });
    } else {
      FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(getFirebaseUser)
          .collection('ExerciseInfo')
          .doc(sol[0][index])
          .collection("Details")
          .doc(uuid.v1().toString())
          .set({
        "time": DateTime.now(),
        "reps": int.parse(_reps[index].text),
        "sets": int.parse(_sets[index].text),
        "weight": int.parse(_weight[index].text),
      });
    }
    refreshList(index, "finish");
  }

  Future<List<List>> finishedExercise(int index) async {
    sol[1][index][3] = 1;
    return sol;
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
    sol[0].insert(index + 1, sol[0][index]);
    sol[1].insert(index + 1, [0, 0, 0, 0, 0]);
    _sets.insert(index + 1, TextEditingController());
    _reps.insert(index + 1, TextEditingController());
    _weight.insert(index + 1, TextEditingController());
    textbox++;
    _sets[index + 1].text = sol[1][index + 1][0].toString();
    _reps[index + 1].text = sol[1][index + 1][1].toString();
    _weight[index + 1].text = sol[1][index + 1][2].toString();

    return sol;
  }

  Future<List<List>> getUserWorkoutPlans() async {
    sol = [];
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
    final List<DocumentSnapshot> documents = result.docs;
    for (int i = 0; i < documents.length; i++) {
      for (int j = 0; j < documents[i]["Exercise Data"].length; j++) {
        workoutPlans.add(documents[i]['Exercise Name']);
        workoutData.add([
          documents[i]["Exercise Data"][j]["reps"],
          documents[i]["Exercise Data"][j]["sets"],
          documents[i]["Exercise Data"][j]["weight"],
          documents[i]["Exercise Data"][j]["finished"],
          0,
          documents[i]["Exercise Data"][j]["uuid"],
        ]);

        _sets[textbox].text =
            documents[i]["Exercise Data"][j]["sets"].toString();
        _reps[textbox].text =
            documents[i]["Exercise Data"][j]["reps"].toString();
        _weight[textbox].text =
            documents[i]["Exercise Data"][j]["weight"].toString();
        textbox++;
      }
    }
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
          if (projectSnap.data[0].length == 0)
            return Text("You currently have no exercises!");
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
                        Row(
                          children: <Widget>[
                            TextButton(
                                child: Text("New Set"),
                                onPressed: () {
                                  refreshList(index, "add");
                                }),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                refreshList(index, "remove");
                              },
                            ),
                          ],
                        ),
                      ])),
                      onDismissed: (action) =>
                          dismissSlidableItem(context, index, action),
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

  Widget projectWidget2() {
    return new FutureBuilder<List<List>>(
      future: _listFuture,
      builder: (BuildContext context, AsyncSnapshot<List<List>> projectSnap) {
        if (!projectSnap.hasData) {
          return Container();
        } else {
          if (projectSnap.data[0].length == 0)
            return Text("You currently have no exercises!");
          return Row(children: [
            Expanded(
              child: SizedBox(
                height: 100000.0,
                child: new ListView.builder(
                  itemCount: projectSnap.data[0].length,
                  itemBuilder: (BuildContext context, int index) {
                    if (projectSnap.data[1][index][3] == 0) {
                      return SlidableWidget(
                        child: Card(
                            child: Column(children: <Widget>[
                          ListTile(
                            title: Text(projectSnap.data[0][index]),
                            trailing: Icon(Icons.check),
                            onTap: () => completedExercise(index),
                          ),
                          Row(children: <Widget>[
                            new Flexible(
                                child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text) {
                                if (num.tryParse(text) != null) {
                                  saveToExercise();
                                }
                              },
                              controller: _sets[index],
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter sets'),
                            )),
                            new Flexible(
                                child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text1) {
                                if (num.tryParse(text1) != null) {
                                  saveToExercise();
                                }
                              },
                              controller: _reps[index],
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter reps'),
                            )),
                            new Flexible(
                                child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onChanged: (text2) {
                                if (num.tryParse(text2) != null) {
                                  saveToExercise();
                                }
                              },
                              controller: _weight[index],
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Enter Weight'),
                            )),
                          ]),
                          Row(
                            children: <Widget>[
                              TextButton(
                                  child: Text("New Set"),
                                  onPressed: () {
                                    refreshList(index, "add");
                                  }),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  refreshList(index, "remove");
                                },
                              ),
                            ],
                          ),
                        ])),
                        onDismissed: (action) =>
                            dismissSlidableItem(context, index, action),
                      );
                    } else {
                      return SlidableWidget(
                        child: Card(
                            child: Column(children: <Widget>[
                          ListTile(
                            title: Text(projectSnap.data[0][index],
                                style: TextStyle(
                                    decoration: TextDecoration.lineThrough)),
                            trailing: Icon(Icons.check),
                            onTap: () => Utils.showSnackBar(
                                context,
                                'Exercise ' +
                                    projectSnap.data[0][index] +
                                    ' is already completed'),
                          ),
                          Row(children: <Widget>[
                            new Flexible(
                                child: TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _sets[index],
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Sets',
                                  filled: true),
                              enabled: false,
                            )),
                            new Flexible(
                                child: TextFormField(
                              controller: _reps[index],
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  labelText: 'Reps',
                                  filled: true),
                              enabled: false,
                            )),
                            new Flexible(
                                child: TextFormField(
                              controller: _weight[index],
                              decoration: InputDecoration(
                                border: UnderlineInputBorder(),
                                labelText: 'Weight',
                                filled: true,
                              ),
                              enabled: false,
                            )),
                          ]),
                          Row(
                            children: <Widget>[
                              TextButton(
                                  child: Text("New Set"),
                                  onPressed: () {
                                    refreshList(index, "add");
                                  }),
                              TextButton(
                                child: const Text('Delete'),
                                onPressed: () {
                                  refreshList(index, "remove");
                                },
                              ),
                            ],
                          ),
                        ])),
                        onDismissed: (action) =>
                            dismissSlidableItem(context, index, action),
                      );
                    }
                  },
                ),
              ),
            ),
          ]);
        }
      },
    );
  }

  void dismissSlidableItem(
      BuildContext context, int index, SlidableAction action) {
    setState(() {});

    switch (action) {
      case SlidableAction.delete:
        refreshList(index, "remove");
        break;
      case SlidableAction.add:
        refreshList(index, "add");
        break;
    }
  }

  void resetProgress() async {
    for (int i = 0; i < sol[0].length; i++) {
      if (sol[1][i][4] == 1) {
        await FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(widget.currentWorkout)
            .collection('Exercises')
            .doc(sol[0][i])
            .update({
          'Exercise Data': FieldValue.arrayRemove([
            {
              "reps": int.parse(_reps[i].text),
              "sets": int.parse(_sets[i].text),
              "weight": int.parse(_weight[i].text),
              "finished": 0,
            }
          ])
        });
      } else {
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
                  "weight": int.parse(_weight[i].text),
                  "finished": 0,
                  "uuid": uuid.v4(),
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
                "weight": int.parse(_weight[i].text),
                "finished": 0,
                "uuid": uuid.v4(),
              }
            ])
          });
        }
      }
    }

    Navigator.pop(context);
  }

  void saveToExercise() async {
    for (int i = 0; i < sol[0].length; i++) {
      if (sol[1][i][4] == 1) {
        await FirebaseFirestore.instance
            .collection('UserInfo')
            .doc(getFirebaseUser)
            .collection('workoutPlans')
            .doc(widget.currentWorkout)
            .collection('Exercises')
            .doc(sol[0][i])
            .update({
          'Exercise Data': FieldValue.arrayRemove([
            {
              "reps": int.parse(_reps[i].text),
              "sets": int.parse(_sets[i].text),
              "weight": int.parse(_weight[i].text),
              "finished": sol[1][i][3],
              "uuid": sol[1][i][5],
            }
          ])
        });
      } else {
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
                  "weight": int.parse(_weight[i].text),
                  "finished": sol[1][i][3],
                  "uuid": uuid.v4(),
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
                "weight": int.parse(_weight[i].text),
                "finished": sol[1][i][3],
                "uuid": uuid.v4(),
              }
            ])
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PLAN: " + widget.currentWorkout),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  refreshList(0, "reset");
                },
                child: Text(
                  'Reset',
                  style: TextStyle(
                      fontFamily: 'Futura',
                      fontSize: 15,
                      color: Color.fromRGBO(255, 255, 255, 1)),
                )),
          ],
        ),
        body: ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          Container(
            child: ElevatedButton(
                child: Text('Add new Exercise'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChooseExercise(
                              currentPlanName: widget.currentWorkout)));
                }),
          ),
          Container(
            child: projectWidget2(),
          ),
        ]));
  }

  void addExercise() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChooseExercise(currentPlanName: widget.currentWorkout)),
    );
  }
}
