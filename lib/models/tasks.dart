import 'package:chronokeeper/models/model.dart';
import 'package:chronokeeper/models/timers.dart';
import 'package:sqflite/sqflite.dart';

import 'database.dart';

class TasksModel extends ChronoKeeperModel {
  int? id;
  String? name;
  int? projectId;
  bool? isCalendarEntry;
  String? description;
  int? parentTaskId;

  TasksModel({
    this.id,
    required this.name,
    required this.projectId,
    required this.isCalendarEntry,
    this.description,
    this.parentTaskId,
  });

  /* Empty Constructor for getting some properties
    that should be static but i can't get them to be static */
  TasksModel.staticInstance();

  @override
  String get tableCreateStmt => '''
    CREATE TABLE IF NOT EXISTS `tasks` (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description STRING,
      project_id INTEGER NOT NULL,
      parent_task_id INTEGER,
      is_calendar_entry INTEGER NOT NULL,
      FOREIGN KEY(project_id) REFERENCES projects(id),
      FOREIGN KEY(parent_task_id) REFERENCES tasks(id)
    )
  ''';

  @override
  String get tableName => 'tasks';

  @override
  String get idField => 'id';

  @override
  int get idValue => id!;

  @override
  List<String> get columns => [
        'id',
        'name',
        'project_id',
        'is_calendar_entry',
        'description',
        'parent_task_id'
      ];

  @override
  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'project_id': projectId,
        'parent_task_id': parentTaskId,
        'is_calendar_entry': (isCalendarEntry ?? false) ? 1 : 0
      };

  @override
  TasksModel fromJson(Map<String, Object?> json) => TasksModel(
        id: json['id'] as int,
        name: json['name'] as String,
        projectId: json['project_id'] as int,
        isCalendarEntry: json['is_calendar_entry'] as int == 1,
        description: json['description'] as String?,
        parentTaskId: json['parent_task_id'] as int?,
      );

  Stream<TasksModel> readSubtasks() async* {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(
      TasksModel.staticInstance().tableName,
      columns: TasksModel.staticInstance().columns,
      where: 'parent_task_id = ?',
      whereArgs: [id],
    );
    for (var map in maps) {
      yield TasksModel.staticInstance().fromJson(map);
    }
  }

  Stream<TimersModel> readTimers() async* {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(
      TimersModel.staticInstance().tableName,
      columns: TimersModel.staticInstance().columns,
      where: 'task_id = ?',
      whereArgs: [id],
    );
    for (var map in maps) {
      yield TimersModel.staticInstance().fromJson(map);
    }
  }
}
