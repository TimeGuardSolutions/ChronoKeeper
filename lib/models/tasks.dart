class TasksModel extends Model {
  final int? id;
  final String? name;
  final String? description;
  final int? project_id;
  final int? parent_task_id;
  final bool? is_calendar_entry;

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
}
