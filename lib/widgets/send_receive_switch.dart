import 'package:codedecoders/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';

import '../screens/send_screen.dart';

class SendReceiveSwitch extends StatelessWidget {
  IconData _switch_icon = Icons.graphic_eq;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white54,
      ),
      padding: EdgeInsets.all(21.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DragTarget(
            builder: (context, List<int> candidateData, rejectedData) {
              return Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.call_received,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Sortir",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              );
            },
            onWillAccept: (data) {
              return true;
            },
            onAccept: (data) {
              Future(() {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Receive!"),
                  ),
                );
                return;
              }).then((_) {
                Navigator.pop(context);
              });
            },
          ),
          Draggable(
            data: 5,
            child: Container(
              width: 51,
              height: 51,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [DEFAULT_COLOR, DEFAULT_COLOR],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _switch_icon,
                color: Colors.white,
              ),
            ),
            feedback: Container(
              width: 51,
              height: 51,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [DEFAULT_COLOR, DEFAULT_COLOR],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 1]),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _switch_icon,
                color: Colors.white,
              ),
            ),
            axis: Axis.horizontal,
            childWhenDragging: Container(
              width: 51,
              height: 51,
            ),
          ),
          DragTarget(
            builder: (context, List<int> candidateData, rejectedData) {
              return Container(
                padding: EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.call_made,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Donation",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ],
                ),
              );
            },
            onWillAccept: (data) {
              return true;
            },
            onAccept: (data) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SendScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
