import 'diary.dart';
import 'diary_media.dart';
import 'tag.dart';

class DiaryEntry {
  const DiaryEntry({
    required this.diary,
    required this.media,
    required this.tags,
  });

  final Diary diary;
  final List<DiaryMedia> media;
  final List<Tag> tags;
}
