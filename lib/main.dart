import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
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
    Text('Home Page'),
    Text('My Workout'),
    Text('My Logs'),
    Text('Settings'),
    Text('Profile'),
  ];

  int currentPage = 0;

  void bottomNavBarClick(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // CollectionReference exercises =
    //     FirebaseFirestore.instance.collection('Exercises');
    var center = Center(
      //child: Text("Hi"),
      child: pages.elementAt(currentPage),
    );
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
