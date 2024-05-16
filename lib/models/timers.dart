import 'package:chronokeeper/models/model.dart';

class TimersModel extends ChronoKeeperModel {
  int? id;
  int? task_id;
  DateTime? start;
  Duration? time_delta;

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

  TimersModel({
    required this.id;
    required this.task_id;
    required this.start;
    required this.time_delta;
  });

  /* Empty Constructor for getting some properties
    that should be static but i can't get them to be static */
  TimersModel();

  @override
  Map<String, Object?> toJson() => {
        'id': id,
        'task_id': task_id,
        // TODO: need for modification before giving it into sqlite?
        'start': start,
        // TODO: need for modification before giving it into sqlite?
        'time_delta': time_delta
      };

  @override
  String get tableName => 'timers';

  @override
  String get idField => 'id';

  @override
  int get idValue => this.id;
}
