import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

enum SlidableAction { delete, add }

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

        /// right side
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.black45,
            icon: Icons.delete,
            onTap: () => onDismissed(SlidableAction.delete),
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
