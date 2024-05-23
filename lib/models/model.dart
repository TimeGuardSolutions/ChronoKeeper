import 'package:sqflite/sqflite.dart';
import 'database.dart';

abstract class ChronoKeeperModel {
  String get tableName;
  String get tableCreateStmt;
  String get idField;
  List<String> get columns;
  int get idValue;

  Map<String, Object?> toJson();
  ChronoKeeperModel fromJson(Map<String, Object?> json);

  Future<void> insert() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.insert(this.tableName, this.toJson());
  }

  Future<void> update() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.update(
      this.tableName,
      this.toJson(),
      where: '${this.idField} = ?',
      whereArgs: [this.idValue],
    );
  }

  Future<void> delete() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.delete(
      this.tableName,
      where: '${this.idField} = ?',
      whereArgs: [this.idValue],
    );
  }

  Future<ChronoKeeperModel?> read(int id) async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(
      this.tableName,
      columns: this.columns,
      where: '${this.idField} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return this.fromJson(maps.first);
    } else {
      return null;
    }
  }

  Stream<ChronoKeeperModel> readMany(List<int> ids) async* {
    if (ids.isEmpty) {
      throw ArgumentError('The list of IDs cannot be empty');
    }

    final Database db = await ChronoKeeperDatabase.instance.db;
    final placeholders = List.generate(ids.length, (index) => '?').join(',');
    final maps = await db.query(
      this.tableName,
      columns: this.columns,
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
    for (var map in maps) {
      yield this.fromJson(map);
    }
  }

  Stream<ChronoKeeperModel> readAll() async* {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(this.tableName);
    for (var map in maps) {
      yield this.fromJson(map);
    }
  }

  Future<Map<int?, ChronoKeeperModel>> createIndex(List<ChronoKeeperModel> models) async {
    Map<int?, ChronoKeeperModel> index = Map();
    for (var model in models) {
      index[model.idValue] = model;
    }
    return index;
  }
}
