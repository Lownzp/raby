import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/domain_validation_exception.dart';
import '../../domain/models/diary.dart';
import '../../domain/models/diary_entry.dart';
import '../../domain/models/diary_media.dart';
import '../../domain/repositories/diary_repository.dart';
import '../database/app_database.dart';
import 'drift_mappers.dart';

class DriftDiaryRepository implements DiaryRepository {
  DriftDiaryRepository(this._database, {Uuid? uuid, DateTime Function()? now})
    : _uuid = uuid ?? const Uuid(),
      _now = now ?? (() => DateTime.now().toUtc());

  final AppDatabase _database;
  final Uuid _uuid;
  final DateTime Function() _now;

  DiaryDao get _dao => _database.diaryDao;

  @override
  Stream<List<DiaryEntry>> watchTimeline(String rabbitId) {
    return _dao
        .watchTimeline(rabbitId)
        .map(
          (bundles) =>
              bundles.map(diaryEntryFromBundle).toList(growable: false),
        );
  }

  @override
  Future<DiaryEntry?> getDiaryEntry(String id) async {
    final bundle = await _dao.getDiaryEntry(id);
    return bundle == null ? null : diaryEntryFromBundle(bundle);
  }

  @override
  Future<void> createDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) {
    _validateDiary(diary: diary, media: media);
    final distinctTagIds = tagIds.toSet().toList(growable: false);
    return _dao.createDiary(
      diary: diaryToCompanion(diary),
      media: media.map(diaryMediaToCompanion).toList(growable: false),
      tagLinks: _tagLinks(
        diaryId: diary.id,
        tagIds: distinctTagIds,
        timestamp: diary.updatedAt,
      ),
    );
  }

  @override
  Future<void> updateDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) {
    _validateDiary(diary: diary, media: media);
    final distinctTagIds = tagIds.toSet().toList(growable: false);
    return _dao.updateDiary(
      diary: diaryToCompanion(diary),
      media: media.map(diaryMediaToCompanion).toList(growable: false),
      tagLinks: _tagLinks(
        diaryId: diary.id,
        tagIds: distinctTagIds,
        timestamp: diary.updatedAt,
      ),
      updatedAt: dateTimeToMillis(diary.updatedAt),
    );
  }

  @override
  Future<void> softDeleteDiary(String id) {
    return _dao.softDeleteDiary(id, dateTimeToMillis(_now()));
  }

  List<DiaryTagsCompanion> _tagLinks({
    required String diaryId,
    required List<String> tagIds,
    required DateTime timestamp,
  }) {
    final millis = dateTimeToMillis(timestamp);
    return tagIds
        .map(
          (tagId) => DiaryTagsCompanion.insert(
            id: _uuid.v4(),
            diaryId: diaryId,
            tagId: tagId,
            createdAt: millis,
            updatedAt: millis,
            deletedAt: const Value(null),
          ),
        )
        .toList(growable: false);
  }

  void _validateDiary({required Diary diary, required List<DiaryMedia> media}) {
    final hasContent = diary.content?.trim().isNotEmpty ?? false;
    if (!hasContent && media.isEmpty) {
      throw const DomainValidationException('日记正文和照片至少需要一个');
    }
    if (media.length > 9) {
      throw const DomainValidationException('单条日记最多支持 9 张照片');
    }
    for (final item in media) {
      if (item.diaryId != diary.id) {
        throw const DomainValidationException('日记媒体必须属于当前日记');
      }
    }
  }
}
