import 'dart:async';
import 'package:chronokeeper/main.dart';
import 'package:flutter/material.dart';

import 'models/model_wrapper.dart';

class TrackingFooter extends StatefulWidget {
  final Data data;

  const TrackingFooter({super.key, required this.data});

  @override
  State<TrackingFooter> createState() => _TrackingState();
}

class _TrackingState extends State<TrackingFooter> {
  bool isRunning = false;
  int elapsedSeconds = 0;
  IconData iconData = Icons.play_arrow;

  void _onTrackTime() {
    isRunning = !isRunning;
    if (isRunning) {
      Timer.periodic(const Duration(milliseconds: 200), (timer) {
        setState(() {
          elapsedSeconds = timer.tick ~/ 5;
          iconData = Icons.stop;
          if (!isRunning) {
            timer.cancel();
            iconData = Icons.play_arrow;
          }
        });
      });
    } else {
      TrackingFooterDialog.openSelectTaskDialog(context, (widget).data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          formatElapsedTime(elapsedSeconds),
          style: const TextStyle(color: Colors.white),
        ),
        Container(
          decoration: const ShapeDecoration(
            color: ChronoKeeper.complementaryColor,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: Icon(iconData),
            color: Colors.black,
            onPressed: _onTrackTime,
          ),
        )
      ],
    );
  }
}

String formatElapsedTime(int elapsedSeconds) {
  int elapsedHours = elapsedSeconds ~/ 3600;
  elapsedSeconds %= 3600;
  String hours = elapsedHours < 10 ? '0$elapsedHours' : '$elapsedHours';
  int elapsedMinutes = elapsedSeconds ~/ 60;
  elapsedSeconds %= 60;
  String minutes = elapsedMinutes < 10 ? '0$elapsedMinutes' : '$elapsedMinutes';
  String seconds = elapsedSeconds < 10 ? '0$elapsedSeconds' : '$elapsedSeconds';
  return '$hours:$minutes:$seconds';
}

class TrackingFooterDialog {
  static String? _selectedProject;

  static Future<String?> openSelectTaskDialog(BuildContext context, Data data) {
    return showDialog<String>(
        context: context,
        builder: (context) => FutureBuilder(
            future: createTaskMenuItems(data),
            builder: (context, AsyncSnapshot<Map<int, String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                            content: DropdownButton<String>(
                                value: _selectedProject,
                                items: snapshot.data?.entries
                                    .map((e) => DropdownMenuItem(
                                        value: e.key.toString(),
                                        child: Text(e.value)))
                                    .toList(),
                                onChanged: (String? selectedValue) {
                                  setState(
                                      () => _selectedProject = selectedValue);
                                }),
                            actions: [
                              TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: const Text("Abbrechen")),
                              TextButton(
                                  onPressed: () => onSave(context),
                                  child: const Text("Speichern"))
                            ],
                          ));
                default:
                  return const Text("Please wait");
              }
            }));
  }

  static void onSave(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Future<Map<int, String>> createTaskMenuItems(Data data) async {
    Map<int, String> taskMenuItems = {};
    for (var project in await data.getProjects()) {
      for (var task in await project.getTasks()) {
        insertTaskMenuItem(taskMenuItems, task, project.getName());
      }
    }
    return taskMenuItems;
  }

  static void insertTaskMenuItem(Map<int, String> taskMenuItems,
      TasksModelWrapper task, String name) async {
    String taskName = "$name - ${task.getName()}";
    taskMenuItems[taskMenuItems.length] = taskName;
    for (var subtask in await task.getSubtasks()) {
      insertTaskMenuItem(taskMenuItems, subtask, taskName);
    }
  }
}
