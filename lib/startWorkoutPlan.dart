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
  Future<List<String>> getUserWorkoutPlans() async {
    _sets[0].text = "17";
    print(currentWorkout);
    String currentUID = FirebaseAuth.instance.currentUser.uid;
    List<String> workoutPlans = [];
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
          // debugPrint("Exercises: ${projectSnap.data.length}");
          return Row(children: [
            Expanded(
              child: SizedBox(
                height: 100000.0,
                child: new ListView.builder(
                  itemCount: projectSnap.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                        child: Column(children: <Widget>[
                      ListTile(
                          title: Text(projectSnap.data[index]),
                          onTap: () => debugPrint(
                              "Clicking ${projectSnap.data[index]} box")),
                      //new Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //children: <Widget>[
                      TextFormField(
                        controller: _sets[index],
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter sets'),
                      ),
                      TextFormField(
                        controller: _reps[index],
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Enter reps'),
                      ),
                      //]),
                      ButtonBar(
                        children: <Widget>[
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
                      fontSize: 12,
                      color: Color.fromRGBO(100, 100, 100, 100)),
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
