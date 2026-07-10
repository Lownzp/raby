import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/diaries.dart';
import 'tables/diary_media_items.dart';
import 'tables/diary_tags.dart';
import 'tables/rabbits.dart';
import 'tables/tags.dart';
import 'tables/weight_records.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Rabbits, Diaries, DiaryMediaItems, Tags, DiaryTags, WeightRecords],
  daos: [RabbitDao, DiaryDao, TagDao, WeightDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onCreate: (m) async {
      await m.createAll();
      await _createIndexes();
    },
  );

  Future<void> _createIndexes() async {
    for (final statement in _schemaIndexes) {
      await customStatement(statement);
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, 'raby.db'));
    return NativeDatabase.createInBackground(file);
  });
}

const _schemaIndexes = [
  'CREATE INDEX idx_rabbits_deleted_at ON rabbits(deleted_at);',
  'CREATE INDEX idx_rabbits_updated_at ON rabbits(updated_at);',
  'CREATE INDEX idx_diaries_rabbit_recorded_at ON diaries(rabbit_id, recorded_at);',
  'CREATE INDEX idx_diaries_deleted_at ON diaries(deleted_at);',
  'CREATE INDEX idx_diaries_updated_at ON diaries(updated_at);',
  'CREATE INDEX idx_diary_media_diary_order ON diary_media(diary_id, sort_order);',
  'CREATE INDEX idx_diary_media_deleted_at ON diary_media(deleted_at);',
  'CREATE INDEX idx_diary_media_updated_at ON diary_media(updated_at);',
  'CREATE INDEX idx_tags_rabbit_id ON tags(rabbit_id);',
  'CREATE INDEX idx_tags_kind ON tags(tag_kind);',
  'CREATE INDEX idx_tags_deleted_at ON tags(deleted_at);',
  'CREATE INDEX idx_tags_updated_at ON tags(updated_at);',
  'CREATE INDEX idx_diary_tags_diary_id ON diary_tags(diary_id);',
  'CREATE INDEX idx_diary_tags_tag_id ON diary_tags(tag_id);',
  'CREATE INDEX idx_diary_tags_deleted_at ON diary_tags(deleted_at);',
  'CREATE INDEX idx_diary_tags_updated_at ON diary_tags(updated_at);',
  'CREATE INDEX idx_weight_records_rabbit_recorded_at ON weight_records(rabbit_id, recorded_at);',
  'CREATE INDEX idx_weight_records_deleted_at ON weight_records(deleted_at);',
  'CREATE INDEX idx_weight_records_updated_at ON weight_records(updated_at);',
];

class DiaryBundleRow {
  const DiaryBundleRow({
    required this.diary,
    required this.media,
    required this.tags,
  });

  final DiaryRow diary;
  final List<DiaryMediaRow> media;
  final List<TagRow> tags;
}

@DriftAccessor(
  tables: [Rabbits, Diaries, DiaryMediaItems, Tags, DiaryTags, WeightRecords],
)
class RabbitDao extends DatabaseAccessor<AppDatabase> with _$RabbitDaoMixin {
  RabbitDao(super.db);

  Stream<List<RabbitRow>> watchActiveRabbits() {
    final query = select(rabbits)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.asc(table.createdAt)]);
    return query.watch();
  }

  Stream<RabbitRow?> watchDefaultRabbit() {
    return watchActiveRabbits().map((rows) => rows.isEmpty ? null : rows.first);
  }

  Future<RabbitRow?> getDefaultRabbit() async {
    final query = select(rabbits)
      ..where((table) => table.deletedAt.isNull())
      ..orderBy([(table) => OrderingTerm.asc(table.createdAt)])
      ..limit(1);
    final rows = await query.get();
    return rows.isEmpty ? null : rows.first;
  }

  Future<void> insertRabbit(RabbitsCompanion rabbit) {
    return into(rabbits).insert(rabbit);
  }

  Future<void> updateRabbit(RabbitsCompanion rabbit) {
    return update(rabbits).replace(rabbit);
  }

  Future<void> softDeleteRabbit(String id, int deletedAt) {
    return transaction(() async {
      await (update(rabbits)..where((table) => table.id.equals(id))).write(
        RabbitsCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
      await (update(
        diaries,
      )..where((table) => table.rabbitId.equals(id))).write(
        DiariesCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
      await (update(tags)..where((table) => table.rabbitId.equals(id))).write(
        TagsCompanion(updatedAt: Value(deletedAt), deletedAt: Value(deletedAt)),
      );
      await (update(
        weightRecords,
      )..where((table) => table.rabbitId.equals(id))).write(
        WeightRecordsCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
      final diaryIds =
          await (select(diaries)..where((table) => table.rabbitId.equals(id)))
              .map((row) => row.id)
              .get();
      if (diaryIds.isEmpty) {
        return;
      }
      await (update(
        diaryMediaItems,
      )..where((table) => table.diaryId.isIn(diaryIds))).write(
        DiaryMediaItemsCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
      await (update(
        diaryTags,
      )..where((table) => table.diaryId.isIn(diaryIds))).write(
        DiaryTagsCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
    });
  }
}

@DriftAccessor(tables: [Diaries, DiaryMediaItems, DiaryTags, Tags])
class DiaryDao extends DatabaseAccessor<AppDatabase> with _$DiaryDaoMixin {
  DiaryDao(super.db);

  Stream<List<DiaryBundleRow>> watchTimeline(String rabbitId) {
    final query = select(diaries)
      ..where(
        (table) => table.rabbitId.equals(rabbitId) & table.deletedAt.isNull(),
      )
      ..orderBy([
        (table) => OrderingTerm.desc(table.recordedAt),
        (table) => OrderingTerm.desc(table.createdAt),
      ]);
    return query.watch().asyncMap(_attachDetails);
  }

  Future<DiaryBundleRow?> getDiaryEntry(String id) async {
    final query = select(diaries)
      ..where((table) => table.id.equals(id) & table.deletedAt.isNull());
    final diary = await query.getSingleOrNull();
    if (diary == null) {
      return null;
    }
    final details = await _attachDetails([diary]);
    return details.single;
  }

  Future<void> createDiary({
    required DiariesCompanion diary,
    required List<DiaryMediaItemsCompanion> media,
    required List<DiaryTagsCompanion> tagLinks,
  }) {
    return transaction(() async {
      await into(diaries).insert(diary);
      if (media.isNotEmpty) {
        await batch((batch) => batch.insertAll(diaryMediaItems, media));
      }
      if (tagLinks.isNotEmpty) {
        await batch((batch) => batch.insertAll(diaryTags, tagLinks));
      }
    });
  }

  Future<void> updateDiary({
    required DiariesCompanion diary,
    required List<DiaryMediaItemsCompanion> media,
    required List<DiaryTagsCompanion> tagLinks,
    required int updatedAt,
  }) {
    return transaction(() async {
      await update(diaries).replace(diary);
      await (update(
        diaryMediaItems,
      )..where((table) => table.diaryId.equals(diary.id.value))).write(
        DiaryMediaItemsCompanion(
          updatedAt: Value(updatedAt),
          deletedAt: Value(updatedAt),
        ),
      );
      await (update(
        diaryTags,
      )..where((table) => table.diaryId.equals(diary.id.value))).write(
        DiaryTagsCompanion(
          updatedAt: Value(updatedAt),
          deletedAt: Value(updatedAt),
        ),
      );
      if (media.isNotEmpty) {
        await batch((batch) => batch.insertAll(diaryMediaItems, media));
      }
      if (tagLinks.isNotEmpty) {
        await batch((batch) => batch.insertAll(diaryTags, tagLinks));
      }
    });
  }

  Future<void> softDeleteDiary(String id, int deletedAt) {
    return transaction(() async {
      await (update(diaries)..where((table) => table.id.equals(id))).write(
        DiariesCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
      await (update(
        diaryMediaItems,
      )..where((table) => table.diaryId.equals(id))).write(
        DiaryMediaItemsCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
      await (update(
        diaryTags,
      )..where((table) => table.diaryId.equals(id))).write(
        DiaryTagsCompanion(
          updatedAt: Value(deletedAt),
          deletedAt: Value(deletedAt),
        ),
      );
    });
  }

  Future<List<DiaryBundleRow>> _attachDetails(List<DiaryRow> diaryRows) async {
    final bundles = <DiaryBundleRow>[];
    for (final diary in diaryRows) {
      bundles.add(
        DiaryBundleRow(
          diary: diary,
          media: await _mediaFor(diary.id),
          tags: await _tagsFor(diary.id),
        ),
      );
    }
    return bundles;
  }

  Future<List<DiaryMediaRow>> _mediaFor(String diaryId) {
    final query = select(diaryMediaItems)
      ..where(
        (table) => table.diaryId.equals(diaryId) & table.deletedAt.isNull(),
      )
      ..orderBy([(table) => OrderingTerm.asc(table.sortOrder)]);
    return query.get();
  }

  Future<List<TagRow>> _tagsFor(String diaryId) async {
    final linkQuery = select(diaryTags)
      ..where(
        (table) => table.diaryId.equals(diaryId) & table.deletedAt.isNull(),
      );
    final tagIds = (await linkQuery.get()).map((link) => link.tagId).toList();
    if (tagIds.isEmpty) {
      return const [];
    }
    final tagQuery = select(tags)
      ..where((table) => table.id.isIn(tagIds) & table.deletedAt.isNull())
      ..orderBy([
        (table) => OrderingTerm.desc(table.tagKind),
        (table) => OrderingTerm.asc(table.sortOrder),
        (table) => OrderingTerm.asc(table.name),
      ]);
    return tagQuery.get();
  }
}

@DriftAccessor(tables: [Tags])
class TagDao extends DatabaseAccessor<AppDatabase> with _$TagDaoMixin {
  TagDao(super.db);

  Stream<List<TagRow>> watchAvailableTags(String rabbitId) {
    return _availableTagsQuery(rabbitId).watch();
  }

  Future<List<TagRow>> getAvailableTags(String rabbitId) {
    return _availableTagsQuery(rabbitId).get();
  }

  Future<TagRow?> getSystemTagByName(String name) {
    final query = select(tags)
      ..where(
        (table) =>
            table.name.equals(name) &
            table.isSystem.equals(true) &
            table.deletedAt.isNull(),
      )
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<void> insertTag(TagsCompanion tag) {
    return into(tags).insert(tag);
  }

  Future<void> softDeleteTag(String id, int deletedAt) {
    return (update(tags)..where((table) => table.id.equals(id))).write(
      TagsCompanion(updatedAt: Value(deletedAt), deletedAt: Value(deletedAt)),
    );
  }

  SimpleSelectStatement<Tags, TagRow> _availableTagsQuery(String rabbitId) {
    return select(tags)
      ..where(
        (table) =>
            (table.isSystem.equals(true) | table.rabbitId.equals(rabbitId)) &
            table.deletedAt.isNull(),
      )
      ..orderBy([
        (table) => OrderingTerm.desc(table.tagKind),
        (table) => OrderingTerm.asc(table.sortOrder),
        (table) => OrderingTerm.asc(table.name),
      ]);
  }
}

@DriftAccessor(tables: [WeightRecords])
class WeightDao extends DatabaseAccessor<AppDatabase> with _$WeightDaoMixin {
  WeightDao(super.db);

  Stream<List<WeightRecordRow>> watchRecords(String rabbitId) {
    return _recordsQuery(rabbitId, ascending: false).watch();
  }

  Stream<List<WeightRecordRow>> watchRecordsForChart(String rabbitId) {
    return _recordsQuery(rabbitId, ascending: true).watch();
  }

  Future<void> insertRecord(WeightRecordsCompanion record) {
    return into(weightRecords).insert(record);
  }

  Future<void> updateRecord(WeightRecordsCompanion record) {
    return update(weightRecords).replace(record);
  }

  Future<void> softDeleteRecord(String id, int deletedAt) {
    return (update(weightRecords)..where((table) => table.id.equals(id))).write(
      WeightRecordsCompanion(
        updatedAt: Value(deletedAt),
        deletedAt: Value(deletedAt),
      ),
    );
  }

  SimpleSelectStatement<WeightRecords, WeightRecordRow> _recordsQuery(
    String rabbitId, {
    required bool ascending,
  }) {
    return select(weightRecords)
      ..where(
        (table) => table.rabbitId.equals(rabbitId) & table.deletedAt.isNull(),
      )
      ..orderBy([
        (table) => ascending
            ? OrderingTerm.asc(table.recordedAt)
            : OrderingTerm.desc(table.recordedAt),
      ]);
  }
}
