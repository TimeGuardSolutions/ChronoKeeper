import 'package:sqflite/sqflite.dart';
import 'package:chronokeeper/models/model.dart';
import 'database.dart';
import 'tasks.dart';

class ProjectsModel extends ChronoKeeperModel {
  int? id;
  String? name;
  String? description;

  ProjectsModel({this.id, required this.name, this.description});

  /* Empty Constructor for getting some properties
      that should be static but i can't get them to be static */
  ProjectsModel.staticInstance();

  @override
  String get tableCreateStmt => '''
    CREATE TABLE IF NOT EXISTS `projects` (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT
    )
  ''';

  @override
  String get tableName => 'projects';

  @override
  String get idField => 'id';

  @override
  List<String> get columns => ['id', 'name', 'description'];

  @override
  int get idValue => id!;

  @override
  Map<String, Object?> toJson() =>
      {'id': id, 'name': name, 'description': description};

  @override
  ProjectsModel fromJson(Map<String, Object?> json) => ProjectsModel(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String?,
      );

  @override
  String toString() {
    return "id: $id\nname: $name\ndescription: $description\n";
  }

  Stream<TasksModel> readTasks() async* {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(
      TasksModel.staticInstance().tableName,
      columns: TasksModel.staticInstance().columns,
      where: 'project_id = ? AND parent_task_id IS NULL',
      whereArgs: [id],
    );
    for (var map in maps) {
      yield TasksModel.staticInstance().fromJson(map);
    }
  }
}
