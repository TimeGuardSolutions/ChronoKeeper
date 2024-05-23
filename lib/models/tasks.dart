import 'package:chronokeeper/models/model.dart';

class TasksModel extends ChronoKeeperModel {
  int? id;
  String? name;
  int? project_id;
  bool? is_calendar_entry;
  String? description;
  int? parent_task_id;

  TasksModel({
    this.id,
    required this.name,
    required this.project_id,
    required this.is_calendar_entry,
    this.description,
    this.parent_task_id,
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
  int get idValue => this.id!;

  @override
  List<String> get columns => [
    'id', 'name', 'project_id', 'is_calendar_entry',
    'description', 'parent_task_id'
  ];

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
  TasksModel fromJson(Map<String, Object?> json) => TasksModel(
    id: json['id'] as int,
    name: json['name'] as String,
    project_id: json['project_id'] as int,
    is_calendar_entry: json['is_calendar_entry'] as bool,
    description: json['description'] as String?,
    parent_task_id: json['parent_task_id'] as int?,
  );
}
