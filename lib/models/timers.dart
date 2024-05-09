import 'package:chronokeeper/models/model.dart';

class TimersModel extends ChronoKeeperModel {
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
  // TODO: implement dbFields
  String get dbFields => throw UnimplementedError();

  @override
  // TODO: implement tableName
  String get tableName => throw UnimplementedError();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();
}
