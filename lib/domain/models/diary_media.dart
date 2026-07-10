import 'raby_enums.dart';

class DiaryMedia {
  const DiaryMedia({
    required this.id,
    required this.diaryId,
    required this.mediaType,
    required this.relativePath,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.thumbnailPath,
    this.mimeType,
    this.width,
    this.height,
    this.fileSizeBytes,
    this.durationMs,
    this.deletedAt,
  });

  final String id;
  final String diaryId;
  final MediaType mediaType;
  final String relativePath;
  final String? thumbnailPath;
  final String? mimeType;
  final int? width;
  final int? height;
  final int? fileSizeBytes;
  final int? durationMs;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
