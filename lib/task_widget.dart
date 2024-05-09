import 'package:chronokeeper/models/test_model.dart';
import 'package:flutter/material.dart';

import 'tracking_footer.dart';

class TaskWidget extends ExpansionTile {
  const TaskWidget(
      {super.key, required super.title, super.subtitle, super.children})
      : super(
            initiallyExpanded: true,
            controlAffinity: ListTileControlAffinity.leading);

  static Widget create(TestTask task) {
    return TaskWidget(
      title: Text(task.name),
      subtitle: Text(task.description ?? ""),
      children: createChildren(task),
    );
  }

  static List<Widget> createChildren(TestTask task) {
    final List<Widget> children = [];
    for (TestTask subtask in task.subtasks ?? []) {
      children.add(TaskWidget.create(subtask));
    }
    for (TestTimer timer in task.timer ?? []) {
      children.add(ListTile(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(timer.toString()),
          Text(formatElapsedTime(timer.timeDelta.inSeconds)),
        ],
      )));
    }
    return children;
  }
}
