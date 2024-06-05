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
    final int _ = await db.insert(tableName, toJson());
  }

  Future<void> update() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.update(
      tableName,
      toJson(),
      where: '$idField = ?',
      whereArgs: [idValue],
    );
  }

  Future<void> delete() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.delete(
      tableName,
      where: '$idField = ?',
      whereArgs: [idValue],
    );
  }

  Future<ChronoKeeperModel?> read(int id) async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(
      tableName,
      columns: columns,
      where: '$idField = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return fromJson(maps.first);
    } else {
      return null;
    }
  }

  Stream<T> readAll<T extends ChronoKeeperModel>() async* {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final maps = await db.query(tableName);
    for (var map in maps) {
      yield fromJson(map) as T;
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
