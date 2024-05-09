import 'package:chronokeeper/models/model.dart';

class ProjectsModel extends ChronoKeeperModel {
  String? name;
  String? description;

  @override
  String get db_fields => '''
    CREATE TABLE IF NOT EXISTS `projects` (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT
    )
  ''';

  @override
  Map<String, Object?> toJson() =>
      {'id': id, 'name': name, 'description': description};

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
