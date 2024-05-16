import 'package:sqflite/sqflite.dart';
import 'database.dart';

abstract class ChronoKeeperModel {
  String get tableName;
  String get tableCreateStmt;
  String get idField;
  int get idValue;

  Map<String, Object?> toJson();

  Future<void> insert() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.insert(this.tableName, this.toJson());
  }

  Future<void> update(ChronoKeeperModel m) async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.update(
      this.tableName,
      this.toJson(),
      where: '${this.idField} = ?',
      whereArgs: [this.idValue],
    );
  }

  Future<void> delete(ChronoKeeperModel m) async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    final int _ = await db.delete(
      this.tableName,
      where: '${this.idField} = ?',
      whereArgs: [this.idValue],
    );
  }
}
