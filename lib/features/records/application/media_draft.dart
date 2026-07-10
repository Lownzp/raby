import '../../../domain/models/diary_media.dart';

sealed class DiaryMediaDraft {
  const DiaryMediaDraft();
}

class ExistingDiaryMediaDraft extends DiaryMediaDraft {
  const ExistingDiaryMediaDraft(this.media);

  final DiaryMedia media;
}

class LocalDiaryMediaDraft extends DiaryMediaDraft {
  const LocalDiaryMediaDraft({
    required this.localPath,
    this.mimeType,
    this.fileSizeBytes,
  });

  final String localPath;
  final String? mimeType;
  final int? fileSizeBytes;
}
