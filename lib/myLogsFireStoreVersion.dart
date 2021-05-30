import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:cse_115a/main.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'workoutPage.dart';

String selectedExercise = "UNINITIALIZED";
String selectedYAxisOption = "Weight";
class WorkoutInfo {
  final int weight;
  final int reps;
  final int sets;
  final DateTime realTimeStamp;

  WorkoutInfo(this.weight, this.reps, this.sets, this.realTimeStamp);

  WorkoutInfo.fromMap(Map<String, dynamic> map)
      : assert(map['weight'] != null),
        assert(map['reps'] != null),
        assert(map['sets'] != null),
        assert(map['time'] != null),
        weight = map['weight'],
        reps = map['reps'],
        sets = map['sets'],
        realTimeStamp = map['time'].toDate();

  @override
  String toString() => "Record<$weight:$reps:$sets:$realTimeStamp>";
}

class WorkoutInfoHomePage extends StatefulWidget {
  @override
  _WorkoutInfoHomePageState createState() {
    return _WorkoutInfoHomePageState();
  }
}

class _WorkoutInfoHomePageState extends State<WorkoutInfoHomePage> {
  List<charts.Series<WorkoutInfo, DateTime>> _seriesData;


  List<WorkoutInfo> myData;

  _generateDataWeight(myData) {
    _seriesData = <charts.Series<WorkoutInfo, DateTime>>[];

    _seriesData.add(
      charts.Series(
        domainFn: (WorkoutInfo info, _) => info.realTimeStamp,
        measureFn: (WorkoutInfo info, _) => info.weight,
        colorFn: (_, __) =>
        charts.MaterialPalette.deepOrange.shadeDefault,
        id: 'WorkoutDetails',
        data: myData,
      ),
    );
  }

  _generateDataReps(myData) {
    _seriesData = <charts.Series<WorkoutInfo, DateTime>>[];

    _seriesData.add(
      charts.Series(
        domainFn: (WorkoutInfo info, _) => info.realTimeStamp,
        measureFn: (WorkoutInfo info, _) => info.reps,
        colorFn: (_, __) =>
        charts.MaterialPalette.deepOrange.shadeDefault,
        id: 'WorkoutDetails',
        data: myData,
      ),
    );
  }

  _generateDataSets(myData) {
    _seriesData = <charts.Series<WorkoutInfo, DateTime>>[];

    _seriesData.add(
      charts.Series(
        domainFn: (WorkoutInfo info, _) => info.realTimeStamp,
        measureFn: (WorkoutInfo info, _) => info.sets,
        colorFn: (_, __) =>
        charts.MaterialPalette.deepOrange.shadeDefault,
        id: 'WorkoutDetails',
        data: myData,
      ),
    );
  }

  Widget toggleExerciseDisplayed(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(1), children: <Widget>[
      Container(
          child: ElevatedButton(

              style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange),

              child: Text('Display an exercise!'),
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => buildLoggedExerciseList(context)),
                );
              })),
    ]);
  }

  Widget toggleYAxis(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(1), children: <Widget>[
      Container(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepOrange),
              child: Text('Toggle Y-Axis'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => displayYAxisOptionPage(context)),
                );
              })),
    ]);
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;


    if(selectedExercise != 'UNINITIALIZED') {
      return MaterialApp(

        home: Scaffold(
          body: ListView( padding: const EdgeInsets.all(8),

              children: <Widget>[

                SizedBox(
                    height: size.height * .10,
                    child: toggleExerciseDisplayed(context)

                ),


                SizedBox(
                    height: size.height * .55,
                    child: DefaultTabController(
                        length: 2,
                        child: Scaffold(
                          appBar: AppBar(
                            backgroundColor: Colors.deepOrange,
                            flexibleSpace: TabBar(
                              indicatorColor: Color(0xffb65f13),
                              tabs: [
                                Tab(
                                  icon: Icon(FontAwesomeIcons.solidChartBar),
                                ),
                                Tab(icon: Icon(FontAwesomeIcons.chartLine)),
                              ],
                            ),
                          ),
                          body: TabBarView(
                              children: [

                                _buildBodyChart(context),
                                _buildBodyLine(context)

                              ]),
                        ))),

                SizedBox(
                    height: size.height * .10,
                    child: toggleYAxis(context)

                )
              ]
          ),
        ),

      );
    }

    else
    {
      return MaterialApp(

        home: Scaffold(
          body: ListView( padding: const EdgeInsets.all(8),

              children: <Widget>[

                SizedBox(
                    height: size.height * .10,
                    child: toggleExerciseDisplayed(context)

                ),


              ]
          ),
        ),

      );
    }
  }

  Widget _buildBodyLine(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(getFirebaseUser)
          .collection('ExerciseInfo')
          .doc(selectedExercise)
          .collection('Details')
          .orderBy('time', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<WorkoutInfo> info = snapshot.data.docs
              .map((documentSnapshot) =>
              WorkoutInfo.fromMap(documentSnapshot.data()))
              .toList();
          return _buildLine(context, info);
        }
      },
    );
  }

  Widget _buildLine(BuildContext context, List<WorkoutInfo> infoData) {
    myData = infoData;

    if (selectedYAxisOption.toLowerCase() == "reps") {
      _generateDataReps(myData);
    }
    else if (selectedYAxisOption.toLowerCase() == "sets") {
      _generateDataSets(myData);

    }
    else {
      _generateDataWeight(myData);

    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Progress of ' + selectedYAxisOption.toLowerCase() + ' for ' + selectedExercise,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: charts.TimeSeriesChart(
                    _seriesData,


                  defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, stacked: true,
                      includePoints: true
                  ),
                    animate: true,
                    animationDuration: Duration(seconds: 1),

                    dateTimeFactory: const charts.LocalDateTimeFactory(),
                    domainAxis: charts.DateTimeAxisSpec(
                      tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                        day: new charts.TimeFormatterSpec(
                            format: 'd', transitionFormat: 'MM/dd/yyyy'
                        ),
                      ),
                    ),


                  )

              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBodyChart(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('UserInfo')
          .doc(getFirebaseUser)
          .collection('ExerciseInfo')
          .doc(selectedExercise)
          .collection('Details')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<WorkoutInfo> info = snapshot.data.docs
              .map((documentSnapshot) =>
              WorkoutInfo.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, info);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<WorkoutInfo> infoData) {
    myData = infoData;
    if (selectedYAxisOption.toLowerCase() == "reps") {
      _generateDataReps(myData);
    }
    else if (selectedYAxisOption.toLowerCase() == "sets") {
      _generateDataSets(myData);

    }
    else {
      _generateDataWeight(myData);

    }
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Progress of ' + selectedYAxisOption.toLowerCase() + ' for ' + selectedExercise,
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.TimeSeriesChart(
                  _seriesData,
                  defaultRenderer: new charts.BarRendererConfig<DateTime>(),
                  animate: true,
                  animationDuration: Duration(seconds: 1),

                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                  domainAxis: charts.DateTimeAxisSpec(
                    tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
                      day: new charts.TimeFormatterSpec(
                        format: 'd', transitionFormat: 'MM/dd/yyyy',
                      ),


                    ),
                  ),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> optionsYAxis = ["Weight", "Reps", "Sets"];



  Widget displayYAxisOptionPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a measurement"),

      ),
      body:
      Container(
          child: ListView.builder(
              itemBuilder: displayYAxisCards,
              itemCount: 3
          )
      ),


    );


  }


  Widget displayYAxisCards( BuildContext context, int index ){
    return Card(
      child: ListTile(
          title: Text(optionsYAxis[index]),
          onTap: ()
          {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text( "Selected measurement to be displayed: " +optionsYAxis[index])));
            selectedYAxisOption = optionsYAxis[index];
            selectedYAxisOption.toLowerCase();
            setState(() {

            });
          }
      ),
    );
  }


  final List<String> completedExercises = [];


  Future<void> getCompletedExercises() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('ExerciseInfo')
        .get();

    final List<DocumentSnapshot> customDoc = result.docs;

    for (int i = 0; i < customDoc.length; i++) {
      if (!completedExercises.contains(customDoc[i]["name"])) {
        completedExercises.add(customDoc[i]["name"]);
      }
    }

    return completedExercises;

  }


  Widget buildLoggedExerciseList(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a logged exercise"),

      ),
      body: FutureBuilder(
        builder: (context, projectSnap) {
          if (!projectSnap.hasData) {
            return Container();
          } else {
            return Container(
                child: ListView.builder(
                    itemBuilder: displayLogCards,
                    itemCount: completedExercises.length
                )
            );
          }
        },
        future: getCompletedExercises(),
      ),




    );


  }


  Widget displayLogCards( BuildContext context, int index ){
    return Card(
      child: ListTile(
          title: Text(completedExercises[index]),
          onTap: ()
          {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text( "Selected exercise to be displayed: " +completedExercises[index])));
            selectedExercise = completedExercises[index];
            setState(() {

            });  }
      ),
    );
  }


}