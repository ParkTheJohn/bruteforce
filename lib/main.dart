import 'package:cse_115a/settingsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'exercises.dart';
import 'LoginPage.dart';
import 'LoginService.dart';
import 'workoutPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider<LoginService>(
            create: (_) => LoginService(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) => context.read<LoginService>().authStateChanges,
          ),
        ],
        child: MaterialApp(
          title: 'FitRecur v1',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
          ),
          home: AuthenticationWrapper(),
        ));
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomePage();
    }

    return LoginPage();
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var toExercise = exercisesPage();
  var pageTitles = [
    "Exercises",
    "My Plans",
    "My Workout",
    "My Logs",
    "Settings",
  ];
  static List<Widget> pages = <Widget>[
    exercisesPage(),
    workoutPage(),
    Text('Start Workout'),
    Text('My Logs'),
    settingsPage(),
    LoginPage(),
  ];

  int currentPage = 0;
  String exercise;
  int currentExer = 0;
  void bottomNavBarClick(int index) {
    if (index == 0) {
      toExercise.getExerciseData();
    }
    setState(() {
      currentPage = index;
    });
  }

  // Future<void> _incrementCounter() async {
  //   final QuerySnapshot result =
  //       await Firestore.instance.collection('Exercises').getDocuments();
  //   final List<DocumentSnapshot> documents = result.documents;
  //   exercise = documents[currentExer]['name'];
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     if (currentPage < 150) {
  //       currentExer++;
  //     } else {
  //       currentExer--;
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitles[currentPage]),
      ),
      body: pages.elementAt(currentPage),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Exercises',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            //icon: Icon(Icons.fitness_center),
            icon: Icon(Icons.my_library_books),
            label: 'My Plans',
            backgroundColor: Colors.deepOrange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Start Workout',
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
        ],
        currentIndex: currentPage,
        selectedItemColor: Colors.orangeAccent,
        onTap: bottomNavBarClick,
      ),
    );
  }
}
