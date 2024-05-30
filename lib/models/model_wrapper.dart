import 'package:chronokeeper/models/projects.dart';
import 'package:chronokeeper/models/tasks.dart';
import 'package:chronokeeper/models/timers.dart';
import 'package:intl/intl.dart';

abstract class TaskContainer {
  int getId();
  Future<void> addTask(TasksModel task);
}

class ProjectsModelWrapper implements TaskContainer {
  final ProjectsModel project;
  Map<int, TasksModelWrapper> tasksCache = {};
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

  Future<Iterable<TasksModelWrapper>> getTasks() async {
    if (isOutdated) {
      isOutdated = false;
      tasksCache = await createNewCache();
    }
    return tasksCache.values;
  }

  Future<Map<int, TasksModelWrapper>> createNewCache() async {
    Map<int, TasksModelWrapper> tasks = {};
    await for (var task in project.readTasks()) {
      tasks[task.id ?? -1] = TasksModelWrapper(task: task);
    }
    return tasks;
  }

  @override
  Future<void> addTask(TasksModel task) async {
    isOutdated = true;
    await task.insert();
  }

  Future<int> getTotalTimeInSeconds() async {
    int totalSeconds = 0;
    for (var task in await getTasks()) {
      totalSeconds += await task.getTotalTimeInSeconds();
    }
    return totalSeconds;
  }

  Future<Iterable<String>> wasWorkedOn() async {
    Set<String> wasWorkedOn = {};
    for (var task in await getTasks()) {
      wasWorkedOn.addAll(await task.wasWorkedOn());
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
  Map<int, TasksModelWrapper> subtasksCache = {};
  bool isSubtasksCacheOutdated = true;
  Map<int, TimersModelWrapper> timersCache = {};
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

  Future<Iterable<TasksModelWrapper>> getSubtasks() async {
    if (isSubtasksCacheOutdated) {
      isSubtasksCacheOutdated = false;
      subtasksCache = await createNewSubtasksCache();
    }
    return subtasksCache.values;
  }

  Future<Map<int, TasksModelWrapper>> createNewSubtasksCache() async {
    Map<int, TasksModelWrapper> subtasks = {};
    await for (var subtask in task.readSubtasks()) {
      subtasks[subtask.id ?? -1] = TasksModelWrapper(task: subtask);
    }
    return subtasks;
  }

  Future<Iterable<TimersModelWrapper>> getTimers() async {
    if (isTimersCacheOutdated) {
      isTimersCacheOutdated = false;
      timersCache = await createNewTimersCache();
    }
    return timersCache.values;
  }

  Future<Iterable<TimersModelWrapper>> getAllTimersForDate(String date) async {
    List<TimersModelWrapper> timers = [];
    for (TimersModelWrapper timer in await getTimers()) {
      if (date == formatter.format(timer.getStart())) {
        timers.add(timer);
      }
    }
    return timers;
  }

  Future<Map<int, TimersModelWrapper>> createNewTimersCache() async {
    Map<int, TimersModelWrapper> timers = {};
    await for (var timer in task.readTimers()) {
      timers[timer.id ?? -1] = TimersModelWrapper(
          timer: TimersModel(
              taskId: timer.taskId,
              start: timer.start,
              timeDelta: timer.timeDelta));
    }
    return timers;
  }

  @override
  Future<void> addTask(TasksModel task) async {
    isSubtasksCacheOutdated = true;
    task.parentTaskId = getId();
    await task.insert();
  }

  Future<void> addTimer(TimersModel timer) async {
    isTimersCacheOutdated = true;
    await timer.insert();
  }

  Future<int> getTotalTimeInSeconds() async {
    int totalSeconds = 0;
    for (TasksModelWrapper task in await getSubtasks()) {
      totalSeconds += await task.getTotalTimeInSeconds();
    }
    for (TimersModelWrapper timer in await getTimers()) {
      totalSeconds += timer.getTimeDelta().inSeconds;
    }
    return totalSeconds;
  }

  Future<bool> wasWorkedOnDate(String date) async {
    return (await wasWorkedOn()).contains(date);
  }

  Future<Iterable<String>> wasWorkedOn() async {
    Set<String> wasWorkedOn = {};
    for (TasksModelWrapper task in await getSubtasks()) {
      wasWorkedOn.addAll(await task.wasWorkedOn());
    }
    for (TimersModelWrapper timer in await getTimers()) {
      wasWorkedOn.add(formatter.format(timer.getStart()));
    }
    return wasWorkedOn;
  }
}

class TimersModelWrapper {
  final TimersModel timer;
  static final DateFormat formatter = DateFormat("HH:mm");

  TimersModelWrapper({required this.timer});

  DateTime getStart() {
    return timer.start!;
  }

  Duration getTimeDelta() {
    return timer.timeDelta!;
  }

  @override
  String toString() {
    return "${formatter.format(getStart())}-${formatter.format(getStart().add(getTimeDelta()))}";
  }
}

class Data {
  Map<int, ProjectsModelWrapper> projectsCache = {};
  bool isOutdated = true;

  Future<Iterable<ProjectsModelWrapper>> getProjects() async {
    if (isOutdated) {
      isOutdated = false;
      projectsCache = await createNewProjectsCache();
    }
    return projectsCache.values;
  }

  static Future<Map<int, ProjectsModelWrapper>> createNewProjectsCache() async {
    Map<int, ProjectsModelWrapper> projects = {};
    await for (ProjectsModel project
        in ProjectsModel.staticInstance().readAll()) {
      projects[project.id ?? -1] = ProjectsModelWrapper(project: project);
    }
    return projects;
  }

  void addProject(String name, String? description) async {
    isOutdated = true;
    await ProjectsModel(name: name, description: description).insert();
  }
}

Future<Map<String, List<ProjectsModelWrapper>>> createDateToProjectsMap(
    Data data) async {
  Map<String, List<ProjectsModelWrapper>> dateToProjects = {};
  for (var project in await data.getProjects()) {
    for (String day in await project.wasWorkedOn()) {
      List<ProjectsModelWrapper> projectsOnDay = dateToProjects[day] ?? [];
      projectsOnDay.add(project);
      dateToProjects[day] = projectsOnDay;
    }
  }
  return dateToProjects;
}
