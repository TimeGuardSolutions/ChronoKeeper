import 'package:chronokeeper/models/model.dart';

class TimersModel extends ChronoKeeperModel {
  int? id;
  int? taskId;
  DateTime? start;
  Duration? timeDelta;

  TimersModel({
    this.id,
    required this.taskId,
    required this.start,
    required this.timeDelta,
  });

  /* Empty Constructor for getting some properties
    that should be static but i can't get them to be static */
  TimersModel.staticInstance();

  @override
  String get tableCreateStmt => '''
    CREATE TABLE IF NOT EXISTS `timers` (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      task_id INTEGER NOT NULL,
      start INTEGER NOT NULL,
      time_delta INTEGER NOT NULL,
      FOREIGN KEY(task_id) REFERENCES tasks(id)
    )
  ''';

  @override
  String get tableName => 'timers';

  @override
  String get idField => 'id';

  @override
  int get idValue => id!;

  @override
  List<String> get columns => ['id', 'task_id', 'start', 'time_delta'];

  @override
  Map<String, Object?> toJson() => {
        'id': id,
        'task_id': taskId,
        'start': start?.toIso8601String(),
        'time_delta': timeDelta?.inSeconds,
      };

  @override
  TimersModel fromJson(Map<String, Object?> json) => TimersModel(
        id: json['id'] as int,
        taskId: json['task_id'] as int,
        start: DateTime.parse(json['start'] as String),
        timeDelta: Duration(seconds: json['time_delta'] as int),
      );
}
