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
                    final projectData =
                        await AppBarDialog.openProjectDialog(context);
                    data.addProject(projectData?[0] ?? "", projectData?[1]);
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

  static Future<void> openTaskDialog(BuildContext context, Data data) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    TaskContainer? selectedTaskContainer;
    Map<TaskContainer, String> taskMenuItems =
        createTaskMenuItems(data.getProjects());
    return showDialog<List<String>>(
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (context, setState) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButton<TaskContainer>(
                          value: selectedTaskContainer,
                          items: taskMenuItems.entries
                              .map((e) => DropdownMenuItem<TaskContainer>(
                                  value: e.key, child: Text(e.value)))
                              .toList(),
                          onChanged: (TaskContainer? selectedValue) {
                            setState(
                                () => selectedTaskContainer = selectedValue);
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
                        onPressed: () => onTaskSave(
                            context,
                            selectedTaskContainer,
                            nameController,
                            descriptionController),
                        child: const Text("Speichern"))
                  ],
                )));
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

  static Map<TaskContainer, String> createTaskMenuItems(
      Iterable<ProjectsModelWrapper> projects) {
    Map<TaskContainer, String> taskMenuItems = {};
    for (var project in projects) {
      taskMenuItems[project] = project.getName();
      for (var task in project.getTasks()) {
        insertTaskMenuItem(taskMenuItems, task, project.getName());
      }
    }
    return taskMenuItems;
  }

  static void insertTaskMenuItem(Map<TaskContainer, String> taskMenuItems,
      TasksModelWrapper task, String name) {
    String taskName = "$name - ${task.getName()}";
    taskMenuItems[task] = taskName;
    for (var subtask in task.getSubtasks()) {
      insertTaskMenuItem(taskMenuItems, subtask, taskName);
    }
  }
}
