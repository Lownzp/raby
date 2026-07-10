import 'package:drift/drift.dart';

import 'rabbits.dart';

@DataClassName('TagRow')
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get rabbitId => text().nullable().references(Rabbits, #id)();
  TextColumn get name => text()();
  TextColumn get tagKind => text()();
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  TextColumn get colorToken => text().nullable()();
  TextColumn get iconName => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
