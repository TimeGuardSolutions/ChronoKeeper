import 'package:sqflite/sqflite.dart';
import 'model.dart';

class ChronoKeeperDatabase {
  static final ChronoKeeperDatabase instance = ChronoKeeperDatabase._internal();

  static Database? _database;

  ChronoKeeperDatabase._internal();

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // TODO: this ok on iOS??
    final String databasePath = await getDatabasesPath();
    final path = '$databasePath/chronokeeper.db';
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, _) async {
    // TODO: implement
  }

  Future<void> close() async {
    final Database db = await ChronoKeeperDatabase.instance.db;
    db.close();
    _database = null;
  }
}
