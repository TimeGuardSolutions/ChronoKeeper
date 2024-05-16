import 'package:chronokeeper/models/model.dart';

class TasksModel extends ChronoKeeperModel {
  int? id;
  String? name;
  String? description;
  int? project_id;
  int? parent_task_id;
  bool? is_calendar_entry;

  TasksModel({
    required this.id;
    required this.name;
    required this.project_id;
    required this.is_calendar_entry;
    this.description;
    this.parent_task_id;
  });

  /* Empty Constructor for getting some properties
    that should be static but i can't get them to be static */
  TasksModel();

  @override
  String get db_fields => '''
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
  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'project_id': project_id,
        'parent_task_id': parent_task_id,
        'is_calendar_entry': is_calendar_entry
      };

  @override
  String get tableName => 'tasks';

  @override
  String get idField => 'id';

  @override
  int get idValue => this.id;
}
