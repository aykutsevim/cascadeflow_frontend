import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TaskIcon extends StatelessWidget {
  final int taskType;

  const TaskIcon({super.key, required this.taskType});

  @override
  Widget build(BuildContext context) {
    IconData iconData;

    switch (taskType) {
      case 1:
        iconData = CupertinoIcons.cube_box;
        break;
      case 2:
        iconData = CupertinoIcons.briefcase;
        break;
      case 3:
        iconData = CupertinoIcons.ant_circle;
        break;
      default:
        iconData = CupertinoIcons.question;
        break;
    }

    return Icon(iconData, size: 40.0);
  }
}
