import 'package:chronokeeper/models/projects.dart';
import 'package:flutter/material.dart';

import 'models/test_model.dart';

class ChronoBar extends AppBar {
  ChronoBar({
    super.key,
    required Text super.title,
    required BuildContext context,
    required List<TestProject> projects,
  }) : super(centerTitle: true, elevation: 0.0, actions: [
          MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  child: const Text("Projekt erstellen"),
                  onPressed: () async {
                    final projectData =
                        await AppBarDialog.openProjectDialog(context);
                    await ProjectsModel(
                            name: projectData?[0], description: projectData?[1])
                        .insert();
                  },
                ),
                MenuItemButton(
                  child: const Text("Task erstellen"),
                  onPressed: () async {
                    final taskData =
                        await AppBarDialog.openTaskDialog(context, projects);
                  },
                )
              ],
              builder: (BuildContext context, MenuController controller,
                  Widget? child) {
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                );
              })
        ]);

  static AppBar create(
      String title, BuildContext context, List<TestProject> projects) {
    return ChronoBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      context: context,
      projects: projects,
    );
  }
}

class AppBarDialog {
  static Future<List<String>?> openProjectDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    return showDialog<List<String>>(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: "Projektname eingeben"),
                    onSubmitted: (_) => nameController.clear,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        hintText: "Beschreibung eingeben"),
                    onSubmitted: (_) => descriptionController.clear,
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: Navigator.of(context).pop,
                    child: const Text("Abbrechen")),
                TextButton(
                    onPressed: () => onProjectSave(
                        context, nameController, descriptionController),
                    child: const Text("Speichern"))
              ],
            ));
  }

  static void onProjectSave(
      BuildContext context,
      TextEditingController nameController,
      TextEditingController descriptionController) {
    if (nameController.text.isNotEmpty) {
      Navigator.of(context)
          .pop([nameController.text, descriptionController.text]);
    }
  }

  static Future<List<String>?> openTaskDialog(
      BuildContext context, List<TestProject> projects) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedProject;
    Map<int, String> taskMenuItems = createTaskMenuItems(projects);
    return showDialog<List<String>>(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<String>(
                          value: selectedProject,
                          items: taskMenuItems.entries
                              .map((e) => DropdownMenuItem(
                                  value: e.key.toString(),
                                  child: Text(e.value)))
                              .toList(),
                          onChanged: (String? selectedValue) {
                            setState(() => selectedProject = selectedValue);
                          }),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                            hintText: "Taskname eingeben"),
                        onSubmitted: (_) => nameController.clear,
                      ),
                      TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Beschreibung eingeben"),
                        onSubmitted: (_) => descriptionController.clear,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text("Abbrechen")),
                    TextButton(
                        onPressed: () => onTaskSave(context, selectedProject,
                            nameController, descriptionController),
                        child: const Text("Speichern"))
                  ],
                )));
  }

  static void onTaskSave(
      BuildContext context,
      String? project,
      TextEditingController nameController,
      TextEditingController descriptionController) {
    if (project != null && nameController.text.isNotEmpty) {
      Navigator.of(context)
          .pop([project, nameController.text, descriptionController.text]);
    }
  }

  static Map<int, String> createTaskMenuItems(List<TestProject> projects) {
    Map<int, String> taskMenuItems = {};
    for (var project in projects) {
      taskMenuItems[taskMenuItems.length] = project.name;
      for (var task in project.tasks ?? []) {
        insertTaskMenuItem(taskMenuItems, task, project.name);
      }
    }
    return taskMenuItems;
  }

  static void insertTaskMenuItem(
      Map<int, String> taskMenuItems, TestTask task, String name) {
    String taskName = "$name - ${task.name}";
    taskMenuItems[taskMenuItems.length] = taskName;
    for (var subtask in task.subtasks ?? []) {
      insertTaskMenuItem(taskMenuItems, subtask, taskName);
    }
  }
}
