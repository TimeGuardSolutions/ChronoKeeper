import 'package:intl/intl.dart';

class TestProject {
  final String name;
  final String? description;
  final List<TestTask>? tasks;

  TestProject(
      {required this.name, required this.description, required this.tasks});

  int getTotalTimeInSeconds() {
    int totalSeconds = 0;
    for (TestTask task in tasks ?? []) {
      totalSeconds += task.getTotalTimeInSeconds();
    }
    return totalSeconds;
  }

  List<String> wasWorkedOn() {
    List<String> wasWorkedOn = [];
    for (TestTask task in tasks ?? []) {
      wasWorkedOn.addAll(task.wasWorkedOn());
    }
    return wasWorkedOn;
  }
}

class TestTask {
  final String name;
  final String? description;
  final List<TestTask>? subtasks;
  final List<TestTimer>? timer;
  static final DateFormat formatter = DateFormat("dd.MM.yyyy");

  TestTask(
      {required this.name,
      required this.description,
      required this.subtasks,
      required this.timer});

  int getTotalTimeInSeconds() {
    int totalSeconds = 0;
    for (TestTask task in subtasks ?? []) {
      totalSeconds += task.getTotalTimeInSeconds();
    }
    for (TestTimer timer in timer ?? []) {
      totalSeconds += timer.timeDelta.inSeconds;
    }
    return totalSeconds;
  }

  List<String> wasWorkedOn() {
    List<String> wasWorkedOn = [];
    for (TestTask task in subtasks ?? []) {
      wasWorkedOn.addAll(task.wasWorkedOn());
    }
    for (TestTimer timer in timer ?? []) {
      wasWorkedOn.add(formatter.format(timer.start));
    }
    return wasWorkedOn;
  }
}

class TestTimer {
  final DateTime start;
  final Duration timeDelta;
  static final DateFormat formatter = DateFormat("HH:mm");

  TestTimer({required this.start, required this.timeDelta});

  @override
  String toString() {
    return "${formatter.format(start)}-${formatter.format(start.add(timeDelta))}";
  }
}

final List<TestProject> dummyData = [
  TestProject(name: "Test", description: "Test description", tasks: [
    TestTask(
      name: "Putzen",
      description: "sauber machen",
      subtasks: null,
      timer: [
        TestTimer(start: DateTime.now(), timeDelta: const Duration(hours: 1)),
        TestTimer(
            start: DateTime.fromMillisecondsSinceEpoch(2000),
            timeDelta: const Duration(minutes: 30)),
      ],
    ),
    TestTask(
        name: "Kochen",
        description: "lecker Essen",
        subtasks: null,
        timer: [
          TestTimer(
              start: DateTime.fromMillisecondsSinceEpoch(100000),
              timeDelta: const Duration(seconds: 4500))
        ]),
  ])
];

Map<String, List<TestProject>> createMap(List<TestProject> projects) {
  Map<String, List<TestProject>> dateToProjects = {};
  for (TestProject project in projects) {
    for (String day in project.wasWorkedOn()) {
      List<TestProject> projectsOnDay = dateToProjects[day] ?? [];
      projectsOnDay.add(project);
      dateToProjects[day] = projectsOnDay;
    }
  }
  return dateToProjects;
}
