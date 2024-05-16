import 'package:flutter/material.dart';

class ChronoBar extends AppBar {
  ChronoBar({
    super.key,
    required Text super.title,
    required BuildContext context,
  }) : super(centerTitle: true, elevation: 0.0, actions: [
          MenuAnchor(
              menuChildren: [
                MenuItemButton(
                  child: const Text("Projekt erstellen"),
                  onPressed: () async {
                    final projectName = await AppBarDialog.openDialog(
                        context, "Projekt eingeben");
                    if (projectName == null || projectName.isEmpty) return;
                  },
                ),
                MenuItemButton(
                  child: const Text("Task erstellen"),
                  onPressed: () async {
                    final taskName =
                        await AppBarDialog.openDialog(context, "Task eingeben");
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

  static AppBar create(String title, BuildContext context) {
    return ChronoBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
      context: context,
    );
  }
}

class AppBarDialog {
  static final controller = TextEditingController();

  static Future<String?> openDialog(BuildContext context, String hintText) =>
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

  static void onSave(BuildContext context) {
    Navigator.of(context).pop(controller.text);
  }
}
