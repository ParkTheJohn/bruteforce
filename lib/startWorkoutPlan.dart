import 'package:cse_115a/workoutPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class startWorkoutPlan extends StatelessWidget {
  final String currentWorkout;
  startWorkoutPlan({Key key, @required this.currentWorkout}) : super(key: key);

  List<TextEditingController> _sets = [
    for (int i = 1; i < 75; i++) TextEditingController()
  ];

  List<TextEditingController> _reps = [
    for (int i = 1; i < 75; i++) TextEditingController()
  ];

  List<TextEditingController> _weight = [
    for (int i = 1; i < 75; i++) TextEditingController()
  ];

  Future<List<List>> getUserWorkoutPlans() async {
    print(currentWorkout);
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    List<String> workoutPlans = [];
    List<List> sol = [];
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(currentUID)
        .collection('workoutPlans')
        .doc(currentWorkout)
        .collection('Exercises')
        .get();
    debugPrint("WORKOUT PLAN IS: " + currentWorkout);
    var list = result.docs;
    final List<DocumentSnapshot> documents = result.docs;
    //debugPrint(list.toString());
    debugPrint(
        "Number of exercises in plan is: " + documents.length.toString());
    //debugPrint(documents[0]['Exercise Name']);
    for (int i = 0; i < documents.length; i++) {
      workoutPlans.add(documents[i]['Exercise Name']);

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
    return sol;
  }

  Widget projectWidget() {
    return FutureBuilder(
      future: getUserWorkoutPlans(),
      builder: (context, projectSnap) {
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
                    return new Card(
                        child: Column(children: <Widget>[
                      ListTile(
                          title: Text(projectSnap.data[0][index]),
                          onTap: () => debugPrint(
                              "Clicking ${projectSnap.data[0][index]} box")),
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
                                print("Test");
                              }),
                          TextButton(
                            child: const Text('BTN1'),
                            onPressed: () {
                              print(_sets[index].text);
                              print(_reps[index].text);
                            },
                          ),
                          TextButton(
                            child: const Text('BTN2'),
                            onPressed: () {/* ... */},
                          ),
                        ],
                      ),
                    ])
                        // child: ListTile(
                        //   title: Text(projectSnap.data[index]),
                        //   onTap: () => debugPrint(
                        //       "Clicking ${projectSnap.data[index]} box"),
                        // ),
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

  void saveToExercise() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("PLAN: " + currentWorkout),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  print("TEST");
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
          Container(
              // child: ElevatedButton(
              //     child: Text('Test'),
              //     onPressed: () {
              //       Text("Hi");
              // })
              ),
          // Container(
          //   child: ElevatedButton(child: Text('Plan 1'), onPressed: () {}),
          // ),
          Container(
            child: projectWidget(),
          ),
        ]));
  }
}
