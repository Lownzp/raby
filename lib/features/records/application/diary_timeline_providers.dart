import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers/repository_providers.dart';
import '../../../domain/models/diary_entry.dart';

final diaryTimelineProvider = StreamProvider.family<List<DiaryEntry>, String>((
  ref,
  rabbitId,
) {
  return ref.watch(diaryRepositoryProvider).watchTimeline(rabbitId);
});

final diaryEntryProvider = FutureProvider.family<DiaryEntry?, String>((
  ref,
  diaryId,
) {
  return ref.watch(diaryRepositoryProvider).getDiaryEntry(diaryId);
});
