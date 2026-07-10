import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../../../app/providers/repository_providers.dart';
import '../../../domain/domain_validation_exception.dart';
import '../../../domain/models/diary.dart';
import '../../../domain/models/diary_entry.dart';
import '../../../domain/models/diary_media.dart';
import '../../../domain/models/raby_enums.dart';
import '../../../domain/models/tag.dart';
import 'media_draft.dart';

class DiaryEditorInput {
  const DiaryEditorInput({
    required this.rabbitId,
    required this.content,
    required this.recordedAt,
    required this.tagIds,
    this.mediaDrafts = const [],
  });

  final String rabbitId;
  final String content;
  final DateTime recordedAt;
  final List<String> tagIds;
  final List<DiaryMediaDraft> mediaDrafts;
}

final diaryEditorControllerProvider = Provider<DiaryEditorController>((ref) {
  return DiaryEditorController(ref);
});

class DiaryEditorController {
  const DiaryEditorController(this._ref);

  final Ref _ref;

  Future<void> create(DiaryEditorInput input) async {
    final now = _ref.read(clockProvider)();
    final content = _trimToNull(input.content);
    _validateContentAndMedia(content: content, mediaDrafts: input.mediaDrafts);
    final diaryId = _ref.read(uuidProvider).v4();
    final diary = Diary(
      id: diaryId,
      rabbitId: input.rabbitId,
      recordedAt: input.recordedAt.toUtc(),
      content: content,
      createdAt: now,
      updatedAt: now,
    );

    final copiedRelativePaths = <String>[];
    try {
      final media = await _buildMedia(
        diaryId: diaryId,
        mediaDrafts: input.mediaDrafts,
        now: now,
        copiedRelativePaths: copiedRelativePaths,
      );
      await _ref
          .read(diaryRepositoryProvider)
          .createDiary(
            diary: diary,
            media: media,
            tagIds: _distinct(input.tagIds),
          );
    } catch (_) {
      await _cleanupCopiedMedia(copiedRelativePaths);
      rethrow;
    }
  }

  Future<void> update({
    required DiaryEntry existing,
    required DiaryEditorInput input,
  }) async {
    final now = _ref.read(clockProvider)();
    final content = _trimToNull(input.content);
    _validateContentAndMedia(content: content, mediaDrafts: input.mediaDrafts);
    final diary = Diary(
      id: existing.diary.id,
      rabbitId: input.rabbitId,
      recordedAt: input.recordedAt.toUtc(),
      content: content,
      createdAt: existing.diary.createdAt,
      updatedAt: now,
      deletedAt: existing.diary.deletedAt,
    );

    final copiedRelativePaths = <String>[];
    try {
      final media = await _buildMedia(
        diaryId: existing.diary.id,
        mediaDrafts: input.mediaDrafts,
        now: now,
        copiedRelativePaths: copiedRelativePaths,
      );
      await _ref
          .read(diaryRepositoryProvider)
          .updateDiary(
            diary: diary,
            media: media,
            tagIds: _distinct(input.tagIds),
          );
    } catch (_) {
      await _cleanupCopiedMedia(copiedRelativePaths);
      rethrow;
    }
  }

  Future<void> delete(String diaryId) {
    return _ref.read(diaryRepositoryProvider).softDeleteDiary(diaryId);
  }

  Future<Tag> createCustomTag({
    required String rabbitId,
    required String name,
  }) {
    return _ref
        .read(tagRepositoryProvider)
        .createCustomTag(
          rabbitId: rabbitId,
          name: name,
          tagKind: TagKind.normal,
        );
  }

  Future<List<DiaryMedia>> _buildMedia({
    required String diaryId,
    required List<DiaryMediaDraft> mediaDrafts,
    required DateTime now,
    required List<String> copiedRelativePaths,
  }) async {
    if (mediaDrafts.isEmpty) {
      return const [];
    }

    final storage = _ref.read(mediaStorageServiceProvider);
    final uuid = _ref.read(uuidProvider);
    final result = <DiaryMedia>[];

    for (var index = 0; index < mediaDrafts.length; index += 1) {
      final draft = mediaDrafts[index];
      switch (draft) {
        case LocalDiaryMediaDraft(
          :final localPath,
          :final mimeType,
          :final fileSizeBytes,
        ):
          final mediaId = uuid.v4();
          final relativePath = await storage.diaryMediaRelativePath(
            diaryId: diaryId,
            mediaId: mediaId,
            extension: _extensionFromPath(localPath),
          );
          await storage.copyToRelativePath(
            source: File(localPath),
            relativePath: relativePath,
          );
          copiedRelativePaths.add(relativePath);
          result.add(
            DiaryMedia(
              id: mediaId,
              diaryId: diaryId,
              mediaType: MediaType.image,
              relativePath: relativePath,
              mimeType: mimeType,
              fileSizeBytes: fileSizeBytes,
              sortOrder: index,
              createdAt: now,
              updatedAt: now,
            ),
          );
        case ExistingDiaryMediaDraft(media: final existingMedia):
          final mediaId = uuid.v4();
          result.add(
            DiaryMedia(
              id: mediaId,
              diaryId: diaryId,
              mediaType: existingMedia.mediaType,
              relativePath: existingMedia.relativePath,
              thumbnailPath: existingMedia.thumbnailPath,
              mimeType: existingMedia.mimeType,
              width: existingMedia.width,
              height: existingMedia.height,
              fileSizeBytes: existingMedia.fileSizeBytes,
              durationMs: existingMedia.durationMs,
              sortOrder: index,
              createdAt: existingMedia.createdAt,
              updatedAt: now,
            ),
          );
      }
    }

    return result;
  }

  Future<void> _cleanupCopiedMedia(List<String> copiedRelativePaths) async {
    if (copiedRelativePaths.isEmpty) {
      return;
    }

    final storage = _ref.read(mediaStorageServiceProvider);
    for (final relativePath in copiedRelativePaths.reversed) {
      try {
        await storage.deleteRelativePath(relativePath);
      } catch (_) {}
    }
  }
}

String? _trimToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

void _validateContentAndMedia({
  required String? content,
  required List<DiaryMediaDraft> mediaDrafts,
}) {
  if (content == null && mediaDrafts.isEmpty) {
    throw const DomainValidationException('日记正文和照片至少需要一个');
  }
  if (mediaDrafts.length > 9) {
    throw const DomainValidationException('单条日记最多支持 9 张照片');
  }
}

List<String> _distinct(List<String> values) {
  final seen = <String>{};
  return [
    for (final value in values)
      if (seen.add(value)) value,
  ];
}

String _extensionFromPath(String path) {
  final extension = p.extension(path).replaceFirst(RegExp(r'^\.'), '').trim();
  return extension.isEmpty ? 'jpg' : extension.toLowerCase();
}
