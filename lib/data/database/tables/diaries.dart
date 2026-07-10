import 'package:drift/drift.dart';

import 'rabbits.dart';

@DataClassName('DiaryRow')
class Diaries extends Table {
  TextColumn get id => text()();
  TextColumn get rabbitId => text().references(Rabbits, #id)();
  IntColumn get recordedAt => integer()();
  TextColumn get content => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
