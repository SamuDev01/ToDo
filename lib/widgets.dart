import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class TaskCardWidget extends StatelessWidget {
  String title;
  String desc;
  TaskCardWidget({ this.title, this.desc });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30
      ),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(Unnamed Task)",
            style: TextStyle(
              color: Color(0xFF211551),
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(height: 10,),
          Text(
            desc ?? "No Description Added",
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF86829D),
              height: 1.5
            ),
          ),
        ],
      )
    );
  }
}

class TodoWidget extends StatelessWidget {

  final String text;
  final bool isDone; 

  TodoWidget({ this.text, @required this.isDone });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 8
      ),
      child: Row(
        children: [
          Container(
            width: 25,
            height: 25,
            margin: EdgeInsets.only(
              right: 16
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDone ? Color(0xFF7349FE) : Colors.transparent,
              borderRadius: BorderRadius.circular(7),
              border: isDone ? null : Border.all(
                color: Color(0xFF86829D),
                width: 1.5
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(0),
              child: Icon(Icons.check, color: Colors.white, size: 18),
            )
          ),
          Flexible(
            child: Text(
              text ?? "(Unnamed Todo)",
              style: TextStyle(
                color: isDone ? Color(0xFF211551) : Color(0xFF86829D),
                fontSize: 16,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context, Widget child, AxisDirection axisDirection) {
      return child;
    }
}

