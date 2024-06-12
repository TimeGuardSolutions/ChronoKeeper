import 'dart:async';
import 'package:chronokeeper/models/timers.dart';
import 'package:chronokeeper/ui/double_function_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/model_wrapper.dart';

class TrackingFooter extends StatefulWidget {
  final Data data;
  final Function notifyParent;

  const TrackingFooter(
      {super.key, required this.data, required this.notifyParent});

  @override
  State<TrackingFooter> createState() => _TrackingState();
}

class _TrackingState extends State<TrackingFooter> {
  bool isRunning = false;
  DateTime start = DateTime.now();
  int elapsedSeconds = 0;
  IconData iconData = Icons.play_arrow;

  void _onTrackTime() async {
    isRunning = !isRunning;
    if (isRunning) {
      start = DateTime.now();
      Timer.periodic(const Duration(milliseconds: 200), (timer) {
        if (mounted) {
          setState(() {
            elapsedSeconds = timer.tick ~/ 5;
            iconData = Icons.stop;
            if (!isRunning) {
              timer.cancel();
              iconData = Icons.play_arrow;
            }
          });
        }
      });
    } else {
      bool? timerWasAdded = await TrackingFooterDialog.openSelectTaskDialog(
          context, (widget).data, start, Duration(seconds: elapsedSeconds));
      if (timerWasAdded != null && timerWasAdded) {
        (widget).notifyParent.call();
      }
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
        DoubleFunctionButton(
            iconData: iconData,
            onTap: _onTrackTime,
            onLongPress: () async {
              bool? timerWasAdded = await TrackingFooterDialog.openTimerDialog(
                  context, widget.data);
              if (timerWasAdded != null && timerWasAdded) {
                (widget).notifyParent.call();
              }
            })
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
  static Future<bool?> openSelectTaskDialog(
      BuildContext context, Data data, DateTime start, Duration timeDelta) {
    TasksModelWrapper? selectedTask;
    return showDialog<bool>(
        context: context,
        builder: (context) => FutureBuilder(
            future: createTaskMenuItems(data),
            builder: (context,
                AsyncSnapshot<Map<TasksModelWrapper, String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                            content: DropdownButton<TasksModelWrapper>(
                                value: selectedTask,
                                items: snapshot.data?.entries
                                    .map((e) => DropdownMenuItem(
                                        value: e.key, child: Text(e.value)))
                                    .toList(),
                                onChanged: (TasksModelWrapper? selectedValue) {
                                  setState(() => selectedTask = selectedValue);
                                }),
                            actions: [
                              TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: const Text("Abbrechen")),
                              TextButton(
                                  onPressed: () => onSave(context, data, start,
                                      timeDelta, selectedTask),
                                  child: const Text("Speichern"))
                            ],
                          ));
                default:
                  return const Text("Please wait");
              }
            }));
  }

  static void onSave(BuildContext context, Data data, DateTime start,
      Duration timeDelta, TasksModelWrapper? selectedTask) {
    if (selectedTask != null) {
      selectedTask.addTimer(TimersModel(
          taskId: selectedTask.getId(), start: start, timeDelta: timeDelta));
      Navigator.of(context).pop(true);
    }
  }

  static Future<Map<TasksModelWrapper, String>> createTaskMenuItems(
      Data data) async {
    Map<TasksModelWrapper, String> taskMenuItems = {};
    for (var project in await data.getProjects()) {
      for (var task in await project.getTasks()) {
        insertTaskMenuItem(taskMenuItems, task, project.getName());
      }
    }
    return taskMenuItems;
  }

  static void insertTaskMenuItem(Map<TasksModelWrapper, String> taskMenuItems,
      TasksModelWrapper task, String name) async {
    String taskName = "$name - ${task.getName()}";
    taskMenuItems[task] = taskName;
    for (var subtask in await task.getSubtasks()) {
      insertTaskMenuItem(taskMenuItems, subtask, taskName);
    }
  }

  static Future<bool?> openTimerDialog(BuildContext context, Data data) {
    DateTime date = DateTime.now();
    TimeOfDay start = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay end = const TimeOfDay(hour: 17, minute: 0);
    TasksModelWrapper? selectedTask;
    return showDialog<bool>(
        context: context,
        builder: (context) => FutureBuilder(
            future: createTaskMenuItems(data),
            builder: (context,
                AsyncSnapshot<Map<TasksModelWrapper, String>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Datum: "),
                                    OutlinedButton(
                                        onPressed: () async {
                                          var newDate = await showDatePicker(
                                              context: context,
                                              firstDate: DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      0),
                                              lastDate: DateTime.now());
                                          if (newDate != null) {
                                            setState(() => date = newDate);
                                          }
                                        },
                                        child: Text(DateFormat("dd.MM.yyyy")
                                            .format(date))),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Text("Start: "),
                                    OutlinedButton(
                                        onPressed: () async {
                                          var timeOfDay = await showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                                hour: 10, minute: 47),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        alwaysUse24HourFormat:
                                                            true),
                                                child: child!,
                                              );
                                            },
                                          );
                                          setState(() {
                                            if (timeOfDay != null) {
                                              start = timeOfDay;
                                            }
                                          });
                                        },
                                        child: Text(formatTimeOfDay(start))),
                                    const Text("Ende: "),
                                    OutlinedButton(
                                        onPressed: () async {
                                          var timeOfDay = await showTimePicker(
                                            context: context,
                                            initialTime: const TimeOfDay(
                                                hour: 10, minute: 47),
                                            builder: (BuildContext context,
                                                Widget? child) {
                                              return MediaQuery(
                                                data: MediaQuery.of(context)
                                                    .copyWith(
                                                        alwaysUse24HourFormat:
                                                            true),
                                                child: child!,
                                              );
                                            },
                                          );
                                          setState(() {
                                            if (timeOfDay != null) {
                                              end = timeOfDay;
                                            }
                                          });
                                        },
                                        child: Text(formatTimeOfDay(end))),
                                  ],
                                ),
                                DropdownButton<TasksModelWrapper>(
                                    value: selectedTask,
                                    items: snapshot.data?.entries
                                        .map((e) => DropdownMenuItem(
                                            value: e.key, child: Text(e.value)))
                                        .toList(),
                                    onChanged:
                                        (TasksModelWrapper? selectedValue) {
                                      setState(
                                          () => selectedTask = selectedValue);
                                    }),
                              ],
                            ),
                            actions: [
                              TextButton(
                                  onPressed: Navigator.of(context).pop,
                                  child: const Text("Abbrechen")),
                              TextButton(
                                  onPressed: () => onTimerSave(context, data,
                                      date, start, end, selectedTask),
                                  child: const Text("Speichern"))
                            ],
                          ));
                default:
                  return const Text("Please wait");
              }
            }));
  }

  static String formatTimeOfDay(TimeOfDay timeOfDay) {
    int dayHours = timeOfDay.hour;
    String hours = dayHours < 10 ? '0$dayHours' : '$dayHours';
    int elapsedMinutes = timeOfDay.minute;
    String minutes =
        elapsedMinutes < 10 ? '0$elapsedMinutes' : '$elapsedMinutes';
    return '$hours:$minutes';
  }

  static void onTimerSave(BuildContext context, Data data, DateTime date,
      TimeOfDay start, TimeOfDay end, TasksModelWrapper? selectedTask) {
    var startOfTimer =
        DateTime(date.year, date.month, date.day, start.hour, start.minute);
    var endOfTimer =
        DateTime(date.year, date.month, date.day, end.hour, end.minute);
    if (endOfTimer.isBefore(startOfTimer)) {
      return;
    }
    onSave(context, data, startOfTimer, endOfTimer.difference(startOfTimer),
        selectedTask);
  }
}
