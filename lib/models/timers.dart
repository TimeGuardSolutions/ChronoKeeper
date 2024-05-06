class TimersModel extends Model {
  final int? id;
  final int? task_id;
  final DateTime? start;
  final Duration? time_delta;

  @override
  String get db_fields => '''
    CREATE TABLE IF NOT EXISTS `timers` (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER NOT NULL,
      start INTEGER NOT NULL,
      time_delta INTEGER NOT NULL,
      FOREIGN KEY(task_id) REFERENCES tasks(id)
    )
  ''';

  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'task_id': task_id,
    // TODO: need for modification before giving it into sqlite?
    'start': start,
    // TODO: need for modification before giving it into sqlite?
    'time_delta': time_delta
  }
}
