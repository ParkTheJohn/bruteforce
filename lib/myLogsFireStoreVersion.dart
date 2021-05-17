import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:cse_115a/main.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'workoutPage.dart';

class WorkoutInfo {
  final int weight;
  final DateTime realTimeStamp;

  WorkoutInfo(this.weight, this.realTimeStamp);

  WorkoutInfo.fromMap(Map<String, dynamic> map)
      : assert(map['weight'] != null),
        assert(map['realTimeStamp'] != null),
        weight = map['weight'],
        realTimeStamp = map['realTimeStamp'].toDate();

  @override
  String toString() => "Record<$weight:$realTimeStamp>";
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

  /*
  //To be implemented when exercises can be logged
  Future <String> getExerciseInfo() async
  {
         await FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('completedExercises')
        .get();
  }
*/
  _generateData(myData) {
    _seriesData = <charts.Series<WorkoutInfo, DateTime>>[];

    _seriesData.add(
      charts.Series(
        domainFn: (WorkoutInfo info, _) => info.realTimeStamp,
        measureFn: (WorkoutInfo info, _) => info.weight,
        colorFn: (_, __) =>
        charts.MaterialPalette.blue.shadeDefault,
        id: 'WorkoutDetails',
        data: myData,
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    return ListView(padding: const EdgeInsets.all(1), children: <Widget>[
      Container(
          child: ElevatedButton(
              child: Text('Display an exercise!'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DisplayCompletedLogs()),
                );
              })),
    ]);
  }


  @override
  Widget build(BuildContext context) {

      return MaterialApp(

        home: Scaffold(
            body: ListView(

                children: <Widget>[

                  SizedBox(
                    width: 50,
                    height: 50,
                    child: buildButton(context)

                  ),



                SizedBox(
                    width: 320.0,
                    height:371.0,
                    child: DefaultTabController(
                length: 2,
                child: Scaffold(
                  appBar: AppBar(
                    flexibleSpace: TabBar(
                      indicatorColor: Color(0xff9962D0),
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

                        _buildBodyChart(context), _buildBodyLine(context)

                      ]),
                )))
                ]
        ),
        ),

      );
  }

  Widget _buildBodyLine(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('test_workout_info')
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
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Heaviest Bench Press lifted this week (lbs)',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                  child: charts.TimeSeriesChart(
                    _seriesData,
                    defaultRenderer: new charts.LineRendererConfig(
                        includeArea: true, stacked: true),
                    animate: true,
                    animationDuration: Duration(seconds: 1),

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
          .collection('test_workout_info')
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
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Heaviest Bench Press lifted this week (lbs)',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayCompletedLogs extends StatelessWidget {

 final List<String> completedExercises = [];


  Future<void> getCompletedExercises() async {

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('test_user_info')
        .doc('placeholder_uid')
        .collection('completedLogs')
        .get();

    final List<DocumentSnapshot> customDoc = result.docs;

    for (int i = 0; i < customDoc.length; i++) {
      completedExercises.add(customDoc[i]["Name"]);
    }

    return completedExercises;

  }


  @override
  Widget build(BuildContext context) {
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
          }
      ),
    );
  }

}

