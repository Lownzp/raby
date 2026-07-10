import 'package:drift/drift.dart';

import 'diaries.dart';
import 'tags.dart';

@DataClassName('DiaryTagRow')
class DiaryTags extends Table {
  TextColumn get id => text()();
  TextColumn get diaryId => text().references(Diaries, #id)();
  TextColumn get tagId => text().references(Tags, #id)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
