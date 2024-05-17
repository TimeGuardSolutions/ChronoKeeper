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
                    final projectName = await AppBarDialog.openProjectDialog(
                        context, "Projekt eingeben");
                    if (projectName == null || projectName.isEmpty) return;
                  },
                ),
                MenuItemButton(
                  child: const Text("Task erstellen"),
                  onPressed: () async {
                    final taskName = await AppBarDialog.openTaskDialog(
                        context, "Task eingeben", projects);
                    if (taskName == null || taskName.isEmpty) return;
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
  static final controller = TextEditingController();
  static String? _selectedProject;

  static Future<String?> openProjectDialog(
          BuildContext context, String hintText) =>
      showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
                content: TextField(
                  autofocus: true,
                  decoration: InputDecoration(hintText: hintText),
                  onSubmitted: (_) => controller.clear,
                ),
                actions: [
                  TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text("Abbrechen")),
                  TextButton(
                      onPressed: () => onSave(context),
                      child: const Text("Speichern"))
                ],
              ));

  static Future<String?> openTaskDialog(
          BuildContext context, String hintText, List<TestProject> projects) =>
      showDialog<String>(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButton<String>(
                            value: _selectedProject,
                            items: List.generate(
                                projects.length,
                                (index) => DropdownMenuItem(
                                    value: projects[index].name,
                                    child: Text(projects[index].name))),
                            onChanged: (String? selectedValue) {
                              setState(() => _selectedProject = selectedValue);
                            }),
                        TextField(
                          decoration: InputDecoration(hintText: hintText),
                          onSubmitted: (_) => controller.clear,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                          onPressed: Navigator.of(context).pop,
                          child: const Text("Abbrechen")),
                      TextButton(
                          onPressed: () => onSave(context),
                          child: const Text("Speichern"))
                    ],
                  )));

  static void onSave(BuildContext context) {
    Navigator.of(context).pop(controller.text);
  }
}
