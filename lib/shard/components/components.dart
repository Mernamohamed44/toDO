import 'package:flutter/material.dart';

Widget buildTaskItem(Map model){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children:  [
         CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blueAccent,
          child:  Text(model['time']),
        ),
        const SizedBox(width: 20,),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(model['title']),
            Text(model['date']),
          ],
        )
      ],
    ),
  );
}