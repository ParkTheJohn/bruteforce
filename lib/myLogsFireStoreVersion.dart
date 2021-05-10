import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class WorkoutInfo {
  final int weight;
  final String timestamp;
  final String colorVal;
  WorkoutInfo(this.weight,this.timestamp,this.colorVal);

  WorkoutInfo.fromMap(Map<String, dynamic> map)
      : assert(map['weight'] != null),
        assert(map['timestamp'] != null),
        assert(map['colorVal'] != null),
        weight = map['weight'],
        colorVal = map['colorVal'],
        timestamp=map['timestamp'];

  @override
  String toString() => "Record<$weight:$timestamp:$colorVal>";
}


class WorkoutInfoHomePage extends StatefulWidget {
  @override
  _WorkoutInfoHomePageState createState() {
    return _WorkoutInfoHomePageState();
  }
}

class _WorkoutInfoHomePageState extends State<WorkoutInfoHomePage> {
  List<charts.Series<WorkoutInfo, String>> _seriesBarData;
  List<WorkoutInfo> mydata;
  _generateData(mydata) {
    _seriesBarData = List<charts.Series<WorkoutInfo, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (WorkoutInfo info, _) => info.timestamp.toString(),
        measureFn: (WorkoutInfo info, _) => info.weight,
        colorFn: (WorkoutInfo info, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(info.colorVal))),
        id: 'WorkoutDetails',
        data: mydata,
        labelAccessorFn: (WorkoutInfo row, _) => "${row.timestamp}",
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Workout Details')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('test_workout_info').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<WorkoutInfo> info = snapshot.data.docs
              .map((documentSnapshot) => WorkoutInfo.fromMap(documentSnapshot.data()))
              .toList();
          return _buildChart(context, info);
        }
      },
    );
  }
  Widget _buildChart(BuildContext context, List<WorkoutInfo> infodata) {
    mydata = infodata;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Highest weight lifted this week (lbs)',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: charts.BarChart(_seriesBarData,
                  animate: true,
                  animationDuration: Duration(seconds:1),

                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}








