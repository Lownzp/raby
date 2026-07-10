import 'package:drift/drift.dart';

import 'diaries.dart';

@DataClassName('DiaryMediaRow')
class DiaryMediaItems extends Table {
  @override
  String get tableName => 'diary_media';

  TextColumn get id => text()();
  TextColumn get diaryId => text().references(Diaries, #id)();
  TextColumn get mediaType => text()();
  TextColumn get relativePath => text()();
  TextColumn get thumbnailPath => text().nullable()();
  TextColumn get mimeType => text().nullable()();
  IntColumn get width => integer().nullable()();
  IntColumn get height => integer().nullable()();
  IntColumn get fileSizeBytes => integer().nullable()();
  IntColumn get durationMs => integer().nullable()();
  IntColumn get sortOrder => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
