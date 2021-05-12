import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_115a/main.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WorkoutInfo {
  final int weight;
  final DateTime realTimeStamp;
  final String colorVal;

  WorkoutInfo(this.weight, this.realTimeStamp, this.colorVal);

  WorkoutInfo.fromMap(Map<String, dynamic> map)
      : assert(map['weight'] != null),
        assert(map['realTimeStamp']!=null),
        assert(map['colorVal'] != null),
        weight = map['weight'],
        realTimeStamp = map['realTimeStamp'].toDate(),
        colorVal = map['colorVal'];

  @override
  String toString() => "Record<$weight:$realTimeStamp:$colorVal>";
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
        colorFn: (WorkoutInfo info, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(info.colorVal))),
        id: 'WorkoutDetails',
        data: myData,
      ),
    );

  }


  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
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
                  children:[

                  _buildBodyChart(context), _buildBodyLine(context)
                    
                  ]),
            )));
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
