import 'package:chronokeeper/models/projects.dart';
import 'package:chronokeeper/models/tasks.dart';
import 'package:intl/intl.dart';

abstract class TaskContainer {
  int getId();
  void addTask(TasksModel task);
}

class ProjectsModelWrapper implements TaskContainer {
  final ProjectsModel project;
  final Map<int, TasksModelWrapper> tasksCache = {};
  bool isOutdated = true;

  ProjectsModelWrapper({required this.project});

  @override
  int getId() {
    return project.id ?? -1;
  }

  String getName() {
    return project.name ?? "";
  }

  String getDescription() {
    return project.description ?? "";
  }

  Iterable<TasksModelWrapper> getTasks() {
    if (isOutdated) {
      isOutdated = false;
      tasksCache.clear();
      updateCache();
    }
    return tasksCache.values;
  }

  void updateCache() async {
    await for (var task in project.readTasks()) {
      tasksCache[task.id ?? -1] = TasksModelWrapper(task: task);
    }
  }

  @override
  void addTask(TasksModel task) async {
    isOutdated = true;
    await task.insert();
  }

  int getTotalTimeInSeconds() {
    int totalSeconds = 0;
    for (var task in getTasks()) {
      totalSeconds += task.getTotalTimeInSeconds();
    }
    return totalSeconds;
  }

  List<String> wasWorkedOn() {
    List<String> wasWorkedOn = [];
    for (var task in getTasks()) {
      wasWorkedOn.addAll(task.wasWorkedOn());
    }
    return wasWorkedOn;
  }

  @override
  String toString() {
    return "name: ${project.name}\nTasks: ${tasksCache.values}\n";
  }
}

class TasksModelWrapper implements TaskContainer {
  final TasksModel task;
  final Map<int, TasksModelWrapper> subtasksCache = {};
  bool isSubtasksCacheOutdated = true;
  final Map<int, TimersModelWrapper> timersCache = {};
  bool isTimersCacheOutdated = true;
  static final DateFormat formatter = DateFormat("dd.MM.yyyy");

  TasksModelWrapper({required this.task});

  @override
  int getId() {
    return task.id ?? -1;
  }

  String getName() {
    return task.name ?? "";
  }

  String getDescription() {
    return task.description ?? "";
  }

  Iterable<TasksModelWrapper> getSubtasks() {
    if (isSubtasksCacheOutdated) {
      isSubtasksCacheOutdated = false;
      subtasksCache.clear();
      updateSubtasksCache();
    }
    return subtasksCache.values;
  }

  void updateSubtasksCache() async {
    await for (var subtask in task.readSubtasks()) {
      subtasksCache[subtask.id ?? -1] = TasksModelWrapper(task: subtask);
    }
  }

  Iterable<TimersModelWrapper> getTimers() {
    if (isTimersCacheOutdated) {
      isTimersCacheOutdated = false;
      timersCache.clear();
      updateTimersCache();
    }
    return timersCache.values;
  }

  void updateTimersCache() async {
    await for (var timer in task.readTimers()) {
      timersCache[timer.id ?? -1] = TimersModelWrapper(
          start: timer.start ?? DateTime.fromMicrosecondsSinceEpoch(0),
          timeDelta: timer.timeDelta ?? const Duration());
    }
  }

  @override
  void addTask(TasksModel task) async {
    isSubtasksCacheOutdated = true;
    task.parentTaskId = getId();
    await task.insert();
  }

  int getTotalTimeInSeconds() {
    int totalSeconds = 0;
    for (TasksModelWrapper task in getSubtasks()) {
      totalSeconds += task.getTotalTimeInSeconds();
    }
    for (TimersModelWrapper timer in getTimers()) {
      totalSeconds += timer.timeDelta.inSeconds;
    }
    return totalSeconds;
  }

  List<String> wasWorkedOn() {
    List<String> wasWorkedOn = [];
    for (TasksModelWrapper task in getSubtasks()) {
      wasWorkedOn.addAll(task.wasWorkedOn());
    }
    for (TimersModelWrapper timer in getTimers()) {
      wasWorkedOn.add(formatter.format(timer.start));
    }
    return wasWorkedOn;
  }
}

class TimersModelWrapper {
  final DateTime start;
  final Duration timeDelta;
  static final DateFormat formatter = DateFormat("HH:mm");

  TimersModelWrapper({required this.start, required this.timeDelta});

  @override
  String toString() {
    return "${formatter.format(start)}-${formatter.format(start.add(timeDelta))}";
  }
}

class Data {
  final Map<int, ProjectsModelWrapper> projectsCache = {};
  bool isOutdated = true;

  Iterable<ProjectsModelWrapper> getProjects() {
    if (isOutdated) {
      isOutdated = false;
      projectsCache.clear();
      updateProjectsCache();
    }
    return projectsCache.values;
  }

  void updateProjectsCache() async {
    await for (ProjectsModel project
        in ProjectsModel.staticInstance().readAll()) {
      projectsCache[project.id ?? -1] = ProjectsModelWrapper(project: project);
    }
  }

  void addProject(String name, String? description) async {
    isOutdated = true;
    await ProjectsModel(name: name, description: description).insert();
  }
}

Map<String, List<ProjectsModelWrapper>> createMap(
    Iterable<ProjectsModelWrapper> projects) {
  Map<String, List<ProjectsModelWrapper>> dateToProjects = {};
  for (ProjectsModelWrapper project in projects) {
    for (String day in project.wasWorkedOn()) {
      List<ProjectsModelWrapper> projectsOnDay = dateToProjects[day] ?? [];
      projectsOnDay.add(project);
      dateToProjects[day] = projectsOnDay;
    }
  }
  return dateToProjects;
}
