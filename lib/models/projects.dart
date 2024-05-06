class ProjectsModel extends Model{
  final int? id;
  final String? name;
  final String? description;

  @override
  String get db_fields => '''
    CREATE TABLE IF NOT EXISTS `projects` (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      description TEXT
    )
  ''';

  @override
  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'description': description
  };

}
