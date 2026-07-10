import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/app/providers/repository_providers.dart';
import 'package:raby/data/media/media_storage_service.dart';
import 'package:raby/domain/domain_validation_exception.dart';
import 'package:raby/domain/models/diary.dart';
import 'package:raby/domain/models/diary_entry.dart';
import 'package:raby/domain/models/diary_media.dart';
import 'package:raby/domain/models/raby_enums.dart';
import 'package:raby/domain/models/tag.dart';
import 'package:raby/domain/repositories/diary_repository.dart';
import 'package:raby/domain/repositories/tag_repository.dart';
import 'package:raby/features/records/application/diary_editor_controller.dart';
import 'package:raby/features/records/application/media_draft.dart';

void main() {
  test('creates a trimmed text diary and deduplicates tag ids', () async {
    final diaryRepository = _FakeDiaryRepository();
    final container = _container(diaryRepository: diaryRepository);
    addTearDown(container.dispose);

    await container
        .read(diaryEditorControllerProvider)
        .create(
          DiaryEditorInput(
            rabbitId: 'rabbit-1',
            content: '  今天吃草很认真  ',
            recordedAt: DateTime.utc(2026, 6, 9, 7),
            tagIds: const ['tag-1', 'tag-1', 'tag-2'],
          ),
        );

    final created = diaryRepository.created.single;
    expect(created.diary.rabbitId, 'rabbit-1');
    expect(created.diary.content, '今天吃草很认真');
    expect(created.diary.createdAt, _now);
    expect(created.media, isEmpty);
    expect(created.tagIds, ['tag-1', 'tag-2']);
  });

  test('rejects empty diary without text or photos', () async {
    final container = _container(diaryRepository: _FakeDiaryRepository());
    addTearDown(container.dispose);

    expect(
      () => container
          .read(diaryEditorControllerProvider)
          .create(
            DiaryEditorInput(
              rabbitId: 'rabbit-1',
              content: '   ',
              recordedAt: _now,
              tagIds: const [],
            ),
          ),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test('creates a media-only diary and copies local image draft', () async {
    final tempDir = await Directory.systemTemp.createTemp('raby-media-test-');
    addTearDown(() => tempDir.delete(recursive: true));
    final source = File('${tempDir.path}${Platform.pathSeparator}photo.jpg');
    await source.writeAsBytes([1, 2, 3]);

    final diaryRepository = _FakeDiaryRepository();
    final mediaStorage = _FakeMediaStorageService();
    final container = _container(
      diaryRepository: diaryRepository,
      mediaStorageService: mediaStorage,
    );
    addTearDown(container.dispose);

    await container
        .read(diaryEditorControllerProvider)
        .create(
          DiaryEditorInput(
            rabbitId: 'rabbit-1',
            content: '   ',
            recordedAt: DateTime.utc(2026, 6, 9, 7),
            tagIds: const [],
            mediaDrafts: [
              LocalDiaryMediaDraft(
                localPath: source.path,
                mimeType: 'image/jpeg',
                fileSizeBytes: 3,
              ),
            ],
          ),
        );

    final created = diaryRepository.created.single;
    expect(created.diary.content, isNull);
    expect(created.media, hasLength(1));
    expect(created.media.single.mediaType, MediaType.image);
    expect(created.media.single.mimeType, 'image/jpeg');
    expect(created.media.single.fileSizeBytes, 3);
    expect(created.media.single.relativePath, endsWith('.jpg'));
    expect(mediaStorage.copied.single.sourcePath, source.path);
    expect(
      mediaStorage.copied.single.relativePath,
      created.media.single.relativePath,
    );
  });

  test('cleans copied local media when repository create fails', () async {
    final tempDir = await Directory.systemTemp.createTemp('raby-media-test-');
    addTearDown(() => tempDir.delete(recursive: true));
    final source = File('${tempDir.path}${Platform.pathSeparator}photo.jpg');
    await source.writeAsBytes([1, 2, 3]);

    final diaryRepository = _FakeDiaryRepository(failOnCreate: true);
    final mediaStorage = _FakeMediaStorageService();
    final container = _container(
      diaryRepository: diaryRepository,
      mediaStorageService: mediaStorage,
    );
    addTearDown(container.dispose);

    await expectLater(
      container
          .read(diaryEditorControllerProvider)
          .create(
            DiaryEditorInput(
              rabbitId: 'rabbit-1',
              content: '照片记录',
              recordedAt: DateTime.utc(2026, 6, 9, 7),
              tagIds: const [],
              mediaDrafts: [LocalDiaryMediaDraft(localPath: source.path)],
            ),
          ),
      throwsA(isA<StateError>()),
    );

    expect(diaryRepository.created, isEmpty);
    expect(mediaStorage.copied, hasLength(1));
    expect(mediaStorage.deleted, [mediaStorage.copied.single.relativePath]);
  });

  test('updates a diary while preserving id and createdAt', () async {
    final diaryRepository = _FakeDiaryRepository();
    final container = _container(diaryRepository: diaryRepository);
    addTearDown(container.dispose);

    final existing = DiaryEntry(
      diary: Diary(
        id: 'diary-1',
        rabbitId: 'rabbit-1',
        recordedAt: DateTime.utc(2026, 6, 8),
        content: '旧内容',
        createdAt: DateTime.utc(2026, 6, 8),
        updatedAt: DateTime.utc(2026, 6, 8),
      ),
      media: const [],
      tags: const [],
    );

    await container
        .read(diaryEditorControllerProvider)
        .update(
          existing: existing,
          input: DiaryEditorInput(
            rabbitId: 'rabbit-1',
            content: '新内容',
            recordedAt: DateTime.utc(2026, 6, 10),
            tagIds: const ['tag-2'],
          ),
        );

    final updated = diaryRepository.updated.single;
    expect(updated.diary.id, 'diary-1');
    expect(updated.diary.content, '新内容');
    expect(updated.diary.createdAt, DateTime.utc(2026, 6, 8));
    expect(updated.diary.updatedAt, _now);
    expect(updated.media, isEmpty);
    expect(updated.tagIds, ['tag-2']);
  });

  test('deletes diary through repository', () async {
    final diaryRepository = _FakeDiaryRepository();
    final container = _container(diaryRepository: diaryRepository);
    addTearDown(container.dispose);

    await container.read(diaryEditorControllerProvider).delete('diary-1');

    expect(diaryRepository.deletedIds, ['diary-1']);
  });

  test('creates custom tag and surfaces duplicate validation', () async {
    final tagRepository = _FakeTagRepository();
    final container = _container(
      diaryRepository: _FakeDiaryRepository(),
      tagRepository: tagRepository,
    );
    addTearDown(container.dispose);

    final tag = await container
        .read(diaryEditorControllerProvider)
        .createCustomTag(rabbitId: 'rabbit-1', name: ' 满月 ');

    expect(tag.name, '满月');
    expect(
      () => container
          .read(diaryEditorControllerProvider)
          .createCustomTag(rabbitId: 'rabbit-1', name: '满月'),
      throwsA(isA<DomainValidationException>()),
    );
  });
}

final _now = DateTime.utc(2026, 6, 9, 8);

ProviderContainer _container({
  required _FakeDiaryRepository diaryRepository,
  _FakeTagRepository? tagRepository,
  MediaStorageService? mediaStorageService,
}) {
  return ProviderContainer(
    overrides: [
      diaryRepositoryProvider.overrideWithValue(diaryRepository),
      tagRepositoryProvider.overrideWithValue(
        tagRepository ?? _FakeTagRepository(),
      ),
      if (mediaStorageService != null)
        mediaStorageServiceProvider.overrideWithValue(mediaStorageService),
      clockProvider.overrideWithValue(() => _now),
    ],
  );
}

class _DiaryWrite {
  const _DiaryWrite({
    required this.diary,
    required this.media,
    required this.tagIds,
  });

  final Diary diary;
  final List<DiaryMedia> media;
  final List<String> tagIds;
}

class _FakeDiaryRepository implements DiaryRepository {
  _FakeDiaryRepository({this.failOnCreate = false});

  final List<_DiaryWrite> created = [];
  final List<_DiaryWrite> updated = [];
  final List<String> deletedIds = [];
  final bool failOnCreate;

  @override
  Stream<List<DiaryEntry>> watchTimeline(String rabbitId) {
    return const Stream.empty();
  }

  @override
  Future<DiaryEntry?> getDiaryEntry(String id) async {
    return null;
  }

  @override
  Future<void> createDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) async {
    if (failOnCreate) {
      throw StateError('create failed');
    }
    created.add(_DiaryWrite(diary: diary, media: media, tagIds: tagIds));
  }

  @override
  Future<void> updateDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) async {
    updated.add(_DiaryWrite(diary: diary, media: media, tagIds: tagIds));
  }

  @override
  Future<void> softDeleteDiary(String id) async {
    deletedIds.add(id);
  }
}

class _CopiedMedia {
  const _CopiedMedia({required this.sourcePath, required this.relativePath});

  final String sourcePath;
  final String relativePath;
}

class _FakeMediaStorageService extends MediaStorageService {
  final List<_CopiedMedia> copied = [];
  final List<String> deleted = [];

  @override
  Future<String> diaryMediaRelativePath({
    required String diaryId,
    required String mediaId,
    String extension = 'jpg',
  }) async {
    return 'media/diaries/$diaryId/$mediaId.$extension';
  }

  @override
  Future<String> copyToRelativePath({
    required File source,
    required String relativePath,
  }) async {
    copied.add(
      _CopiedMedia(sourcePath: source.path, relativePath: relativePath),
    );
    return relativePath;
  }

  @override
  Future<void> deleteRelativePath(String relativePath) async {
    deleted.add(relativePath);
  }
}

class _FakeTagRepository implements TagRepository {
  final List<Tag> tags = [];

  @override
  Future<void> ensureSystemTagsSeeded() async {}

  @override
  Future<List<Tag>> getAvailableTags(String rabbitId) async {
    return List.unmodifiable(tags);
  }

  @override
  Stream<List<Tag>> watchAvailableTags(String rabbitId) {
    return Stream.value(List.unmodifiable(tags));
  }

  @override
  Future<Tag> createCustomTag({
    required String rabbitId,
    required String name,
    TagKind tagKind = TagKind.normal,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty || trimmedName.length > 12) {
      throw const DomainValidationException('标签名需要是 1-12 个字符');
    }
    final duplicated = tags.any(
      (tag) => tag.rabbitId == rabbitId && tag.name == trimmedName,
    );
    if (duplicated) {
      throw const DomainValidationException('同一只兔子的标签名不能重复');
    }
    final tag = Tag(
      id: 'tag-${tags.length + 1}',
      rabbitId: rabbitId,
      name: trimmedName,
      tagKind: tagKind,
      isSystem: false,
      sortOrder: tags.length,
      createdAt: _now,
      updatedAt: _now,
    );
    tags.add(tag);
    return tag;
  }

  @override
  Future<void> softDeleteTag(String id) async {
    tags.removeWhere((tag) => tag.id == id);
  }
}
