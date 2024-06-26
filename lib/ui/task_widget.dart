import 'package:chronokeeper/models/model_wrapper.dart';
import 'package:flutter/material.dart';

import 'tracking_footer.dart';

class TaskWidget extends ExpansionTile {
  const TaskWidget(
      {super.key, required super.title, super.subtitle, super.children})
      : super(
            initiallyExpanded: true,
            controlAffinity: ListTileControlAffinity.leading);

  static Widget create(TasksModelWrapper task, String date) {
    return FutureBuilder(
        future: createChildren(task, date),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return TaskWidget(
                title: Text(task.getName()),
                subtitle: Text(task.getDescription()),
                children: snapshot.data ?? [],
              );
            default:
              return const Text("Please wait");
          }
        });
  }

  static Future<List<Widget>> createChildren(
      TasksModelWrapper task, String date) async {
    final List<Widget> children = [];
    for (TasksModelWrapper subtask in await task.getSubtasks()) {
      children.add(TaskWidget.create(subtask, date));
    }
    for (TimersModelWrapper timer in await task.getAllTimersForDate(date)) {
      children.add(ListTile(
          title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(timer.toString()),
          Text(formatElapsedTime(timer.getTimeDelta().inSeconds)),
        ],
      )));
    }
    return children;
  }
}
