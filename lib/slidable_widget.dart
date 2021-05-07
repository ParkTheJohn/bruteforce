import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cse_115a/chooseExercise.dart';
import 'package:cse_115a/createWorkout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'main.dart';

enum SlidableAction { more, add }

class SlidableWidget<T> extends StatelessWidget {
  final Widget child;
  final Function(SlidableAction action) onDismissed;

  const SlidableWidget({
    @required this.child,
    @required this.onDismissed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        child: child,

        /// left side
        // actions: <Widget>[
        //   IconSlideAction(
        //     caption: 'Archive',
        //     color: Colors.blue,
        //     icon: Icons.archive,
        //     onTap: () => onDismissed(SlidableAction.archive),
        //   ),
        //   IconSlideAction(
        //     caption: 'Share',
        //     color: Colors.indigo,
        //     icon: Icons.share,
        //     onTap: () => onDismissed(SlidableAction.share),
        //   ),
        // ],

        /// right side
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'More',
            color: Colors.black45,
            icon: Icons.more_horiz,
            onTap: () => onDismissed(SlidableAction.more),
          ),
          IconSlideAction(
            caption: 'Add',
            color: Colors.green,
            icon: Icons.add,
            onTap: () => onDismissed(SlidableAction.add),
          ),
        ],
      );
}

/*
Future<IconData> findIcon() async {
  IconData exists;
  await try {
    FirebaseFirestore.instance
        .collection('UserInfo')
        .doc(getFirebaseUser)
        .collection('workoutPlans')
        .doc(getNewPlanName)
        .collection('Exercises')
        .doc(getExercise)
        .get()
        .then((doc) {
      if (doc.exists)
        exists = Icons.remove;
      else
        exists = Icons.add;
    });
    return exists;
  } catch (e) {
    return Icons.add;
  }

  // if (getExercise == 'Axe Hold') {
  //   return Icons.mail;
  // }
  // return Icons.add;
}
*/
