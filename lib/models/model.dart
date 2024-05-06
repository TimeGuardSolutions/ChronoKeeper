import 'database.dart';

abstract class ChronoKeeperModel {
  String get tableName;
  String get dbFields;
  int get id;

  Map<String, Object?> toJson();
}
