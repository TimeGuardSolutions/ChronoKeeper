import 'package:chronokeeper/models/model_wrapper.dart';
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

  static Widget create(ProjectsModelWrapper project) {
    return ProjectWidget(
        title: Text(project.getName()),
        subtitle: Text(project.getDescription()),
        children: createChildren(project.getTasks()));
  }

  static List<Widget> createChildren(Iterable<TasksModelWrapper> tasks) {
    List<Widget> children = [];
    for (TasksModelWrapper task in tasks) {
      children.add(TaskWidget.create(task));
    }
    return children;
  }
}
