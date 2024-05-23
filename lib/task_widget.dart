import 'package:chronokeeper/models/model_wrapper.dart';
import 'package:flutter/material.dart';

import 'tracking_footer.dart';

class TaskWidget extends ExpansionTile {
  const TaskWidget(
      {super.key, required super.title, super.subtitle, super.children})
      : super(
            initiallyExpanded: true,
            controlAffinity: ListTileControlAffinity.leading);

  static Widget create(TasksModelWrapper task) {
    return TaskWidget(
      title: Text(task.getName()),
      subtitle: Text(task.getDescription()),
      children: createChildren(task),
    );
  }

  static List<Widget> createChildren(TasksModelWrapper task) {
    final List<Widget> children = [];
    for (TasksModelWrapper subtask in task.getSubtasks()) {
      children.add(TaskWidget.create(subtask));
    }
    for (TimersModelWrapper timer in task.getTimers()) {
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
