import '../models/diary.dart';
import '../models/diary_entry.dart';
import '../models/diary_media.dart';

abstract interface class DiaryRepository {
  Stream<List<DiaryEntry>> watchTimeline(String rabbitId);
  Future<DiaryEntry?> getDiaryEntry(String id);
  Future<void> createDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  });
  Future<void> updateDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  });
  Future<void> softDeleteDiary(String id);
}
