import 'package:chronokeeper/models/model.dart';

class ProjectsModel extends ChronoKeeperModel {
  int? id;
  String? name;
  String? description;

  ProjectsModel({
    this.id,
    required this.name,
    this.description
  });

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
  int get idValue => this.id!;

  @override
  Map<String, Object?> toJson() =>
      {'id': this.id, 'name': this.name, 'description': this.description};

  @override
  ProjectsModel fromJson(Map<String, Object?> json) => ProjectsModel(
    id: json['id'] as int,
    name: json['name'] as String,
    description: json['description'] as String?,
  );
}
