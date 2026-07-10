import 'package:drift/drift.dart';

import 'rabbits.dart';

@DataClassName('WeightRecordRow')
class WeightRecords extends Table {
  TextColumn get id => text()();
  TextColumn get rabbitId => text().references(Rabbits, #id)();
  IntColumn get recordedAt => integer()();
  IntColumn get weightGrams => integer()();
  TextColumn get note => text().nullable()();
  TextColumn get photoPath => text().nullable()();
  IntColumn get bcsScore => integer().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
