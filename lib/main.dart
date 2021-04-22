import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //FirebaseApp app = await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'FitRecur v1',
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
        ),
        home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print('Error with Future Builder! ${snapshot.error.toString()}');
              return Text('Something is wrong with Builder');
            } else if (snapshot.hasData) {
              return HomePage(title: 'FitRecur Home Page');
            } else {
              //Loading Screen basically
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
        //HomePage(title: 'FitRecur Home Page'),
        );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const List<Widget> pages = <Widget>[
    Text('Home Page', textAlign: TextAlign.center),
    Text('My Workout'),
    Text('My Logs'),
    Text('Settings'),
    Text('Profile'),
  ];

  int currentPage = 0;
  String exercise = "hello";
  int currentExer = 0;
  void bottomNavBarClick(int index) {
    setState(() {
      currentPage = index;
    });
  }

  Future<void> _incrementCounter() async {
    final QuerySnapshot result =
        await Firestore.instance.collection('Exercises').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    exercise = documents[currentExer]['name'];
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      if (currentPage < 150) {
        currentExer++;
      } else {
        currentExer--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var center = Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        pages.elementAt(currentPage),
        Text(exercise),
      ],
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: center,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'My Workouts',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'My Logs',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            backgroundColor: Colors.deepOrange,
          ),
        ],
        currentIndex: currentPage,
        selectedItemColor: Colors.orangeAccent,
        onTap: bottomNavBarClick,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}
