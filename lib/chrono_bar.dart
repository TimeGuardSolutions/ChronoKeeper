import 'package:chronokeeper/models/tasks.dart';
import 'package:flutter/material.dart';

import 'models/model_wrapper.dart';

class ChronoBar extends AppBar {
  ChronoBar({
    super.key,
    required Text super.title,
    required BuildContext context,
    required Data data,
  }) : super(centerTitle: true, elevation: 0.0, actions: [
          MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  child: const Text("Projekt erstellen"),
                  onPressed: () async {
                    await AppBarDialog.openProjectDialog(context, data);
                  },
                ),
                MenuItemButton(
                  child: const Text("Task erstellen"),
                  onPressed: () async {
                    await AppBarDialog.openTaskDialog(context, data);
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

  static AppBar create(String title, BuildContext context, Data data) {
    return ChronoBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      context: context,
      data: data,
    );
  }
}

class AppBarDialog {
  static Future<void> openProjectDialog(BuildContext context, Data data) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    return showDialog<void>(
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
                        context, data, nameController, descriptionController),
                    child: const Text("Speichern"))
              ],
            ));
  }

  static void onProjectSave(
      BuildContext context,
      Data data,
      TextEditingController nameController,
      TextEditingController descriptionController) {
    if (nameController.text.isNotEmpty) {
      data.addProject(nameController.text, descriptionController.text);
      Navigator.of(context).pop();
    }
  }

  static Future<void> openTaskDialog(BuildContext context, Data data) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskContainer? selectedTaskContainer;
    return showDialog<void>(
        context: context,
        builder: (context) => FutureBuilder<Map<TaskContainer, String>>(
            future: createTaskMenuItems(data.getProjects()),
            builder:
                (context, AsyncSnapshot<Map<TaskContainer, String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButton<TaskContainer>(
                                    value: selectedTaskContainer,
                                    items: snapshot.data?.entries
                                        .map((e) =>
                                            DropdownMenuItem<TaskContainer>(
                                                value: e.key,
                                                child: Text(e.value)))
                                        .toList(),
                                    onChanged: (TaskContainer? selectedValue) {
                                      setState(() => selectedTaskContainer =
                                          selectedValue);
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
                                  onSubmitted: (_) =>
                                      descriptionController.clear,
                                )
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: const Text("Abbrechen")),
                              TextButton(
                                  onPressed: () => onTaskSave(
                                      context,
                                      selectedTaskContainer,
                                      nameController,
                                      descriptionController),
                                  child: const Text("Speichern"))
                            ],
                          ));
                default:
                  return const Text("Please wait");
              }
            }));
  }

  static void onTaskSave(
      BuildContext context,
      TaskContainer? taskContainer,
      TextEditingController nameController,
      TextEditingController descriptionController) {
    if (taskContainer != null && nameController.text.isNotEmpty) {
      taskContainer.addTask(TasksModel(
          name: nameController.text,
          projectId: taskContainer.getId(),
          isCalendarEntry: true,
          description: descriptionController.text));
      Navigator.of(context).pop();
    }
  }

  static Future<Map<TaskContainer, String>> createTaskMenuItems(
      Future<Iterable<ProjectsModelWrapper>> projects) async {
    Map<TaskContainer, String> taskMenuItems = {};
    for (var project in await projects) {
      taskMenuItems[project] = project.getName();
      for (var task in await project.getTasks()) {
        insertTaskMenuItem(taskMenuItems, task, project.getName());
      }
    }
    return taskMenuItems;
  }

  static void insertTaskMenuItem(Map<TaskContainer, String> taskMenuItems,
      TasksModelWrapper task, String name) async {
    String taskName = "$name - ${task.getName()}";
    taskMenuItems[task] = taskName;
    for (var subtask in await task.getSubtasks()) {
      insertTaskMenuItem(taskMenuItems, subtask, taskName);
    }
  }
}
