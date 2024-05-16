import 'package:chronokeeper/models/test_model.dart';
import 'package:chronokeeper/task_widget.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class ProjectWidget extends ExpansionTile {
  static const border = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)));

  const ProjectWidget(
      {super.key, required super.title, super.subtitle, super.children})
      : super(
            backgroundColor: ChronoKeeper.tertiaryBackgroundColor,
            collapsedBackgroundColor: ChronoKeeper.tertiaryBackgroundColor,
            shape: border,
            collapsedShape: border,
            clipBehavior: Clip.antiAlias);

  static Widget create(TestProject project) {
    return ProjectWidget(
        title: Text(project.name),
        subtitle: Text(project.description ?? ""),
        children: createChildren(project.tasks ?? []));
  }

  static List<Widget> createChildren(List<TestTask> tasks) {
    List<Widget> children = [];
    for (TestTask task in tasks) {
      children.add(TaskWidget.create(task));
    }
    return children;
  }
}
