import 'package:chronokeeper/models/model_wrapper.dart';
import 'package:chronokeeper/ui/task_widget.dart';
import 'package:flutter/material.dart';

import '../main.dart';

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

  static Widget create(ProjectsModelWrapper project, String date) {
    return FutureBuilder(
        future: createChildren(project, date),
        builder: (context, AsyncSnapshot<List<Widget>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return ProjectWidget(
                  title: Text(project.getName()),
                  subtitle: Text(project.getDescription()),
                  children: snapshot.data ?? []);
            default:
              return const Text("Please wait");
          }
        });
  }

  static Future<List<Widget>> createChildren(
      ProjectsModelWrapper project, String date) async {
    List<Widget> children = [];
    for (TasksModelWrapper task in await project.getTasks()) {
      if (await task.wasWorkedOnDate(date)) {
        children.add(TaskWidget.create(task));
      }
    }
    return children;
  }
}
