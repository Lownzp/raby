import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/data/database/app_database.dart';
import 'package:raby/data/repositories/drift_diary_repository.dart';
import 'package:raby/data/repositories/drift_mappers.dart';
import 'package:raby/data/repositories/drift_rabbit_repository.dart';
import 'package:raby/data/repositories/drift_tag_repository.dart';
import 'package:raby/data/repositories/drift_weight_repository.dart';
import 'package:raby/domain/domain_validation_exception.dart';
import 'package:raby/domain/models/diary.dart';
import 'package:raby/domain/models/diary_media.dart';
import 'package:raby/domain/models/rabbit.dart';
import 'package:raby/domain/models/raby_enums.dart';
import 'package:raby/domain/models/weight_record.dart';

void main() {
  late AppDatabase database;
  late DriftRabbitRepository rabbitRepository;
  late DriftDiaryRepository diaryRepository;
  late DriftTagRepository tagRepository;
  late DriftWeightRepository weightRepository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    rabbitRepository = DriftRabbitRepository(database, now: () => _fixedNow);
    diaryRepository = DriftDiaryRepository(database, now: () => _fixedNow);
    tagRepository = DriftTagRepository(database, now: () => _fixedNow);
    weightRepository = DriftWeightRepository(database, now: () => _fixedNow);
  });

  tearDown(() async {
    await database.close();
  });

  test(
    'returns the first active rabbit as default and hides soft deleted rows',
    () async {
      await rabbitRepository.createRabbit(_rabbit('r1', createdAt: _utc(0)));
      await rabbitRepository.createRabbit(_rabbit('r2', createdAt: _utc(1)));

      expect((await rabbitRepository.getDefaultRabbit())?.id, 'r1');

      await rabbitRepository.softDeleteRabbit('r1');

      expect((await rabbitRepository.getDefaultRabbit())?.id, 'r2');
      final activeRabbits = await rabbitRepository.watchActiveRabbits().first;
      expect(activeRabbits.map((rabbit) => rabbit.id), ['r2']);
    },
  );

  test('seeds system tags once and exposes rabbit custom tags', () async {
    await rabbitRepository.createRabbit(_rabbit('r1'));

    await tagRepository.ensureSystemTagsSeeded();
    await tagRepository.ensureSystemTagsSeeded();
    final custom = await tagRepository.createCustomTag(
      rabbitId: 'r1',
      name: '满月',
      tagKind: TagKind.milestone,
    );

    final tags = await tagRepository.getAvailableTags('r1');
    expect(
      tags.map((tag) => tag.name).where((name) => name == '日常'),
      hasLength(1),
    );
    expect(
      tags.map((tag) => tag.name),
      containsAll(['日常', '晒太阳', '吃草', '剪指甲', '看兽医', '里程碑', '满月']),
    );
    expect(
      tags.firstWhere((tag) => tag.id == custom.id).tagKind,
      TagKind.milestone,
    );

    expect(
      () => tagRepository.createCustomTag(rabbitId: 'r1', name: '满月'),
      throwsA(isA<DomainValidationException>()),
    );
  });

  test('orders diary timeline and aggregates sorted media and tags', () async {
    await rabbitRepository.createRabbit(_rabbit('r1'));
    await tagRepository.ensureSystemTagsSeeded();
    final dailyTag = (await tagRepository.getAvailableTags(
      'r1',
    )).firstWhere((tag) => tag.name == '日常');
    final milestoneTag = await tagRepository.createCustomTag(
      rabbitId: 'r1',
      name: '第一次跳上沙发',
      tagKind: TagKind.milestone,
    );

    await diaryRepository.createDiary(
      diary: _diary('d1', recordedAt: _utc(1), content: '昨天晒太阳'),
      media: const [],
      tagIds: [dailyTag.id],
    );
    await diaryRepository.createDiary(
      diary: _diary('d2', recordedAt: _utc(2), content: '今天精神很好'),
      media: [
        _media('m3', diaryId: 'd2', relativePath: 'media/c.jpg', sortOrder: 2),
        _media('m1', diaryId: 'd2', relativePath: 'media/a.jpg', sortOrder: 0),
        _media('m2', diaryId: 'd2', relativePath: 'media/b.jpg', sortOrder: 1),
      ],
      tagIds: [dailyTag.id, milestoneTag.id, dailyTag.id],
    );

    final timeline = await diaryRepository.watchTimeline('r1').first;
    expect(timeline.map((entry) => entry.diary.id), ['d2', 'd1']);
    expect(timeline.first.media.map((media) => media.relativePath), [
      'media/a.jpg',
      'media/b.jpg',
      'media/c.jpg',
    ]);
    expect(
      timeline.first.tags.map((tag) => tag.name),
      containsAll(['日常', '第一次跳上沙发']),
    );

    await diaryRepository.softDeleteDiary('d2');
    final visibleTimeline = await diaryRepository.watchTimeline('r1').first;
    expect(visibleTimeline.map((entry) => entry.diary.id), ['d1']);
  });

  test(
    'orders weight records for list and chart and validates weight',
    () async {
      await rabbitRepository.createRabbit(_rabbit('r1'));

      await weightRepository.createRecord(
        _weight('w1', recordedAt: _utc(1), grams: 1280),
      );
      await weightRepository.createRecord(
        _weight('w3', recordedAt: _utc(3), grams: 1310),
      );
      await weightRepository.createRecord(
        _weight('w2', recordedAt: _utc(2), grams: 1290),
      );

      final listRecords = await weightRepository.watchRecords('r1').first;
      expect(listRecords.map((record) => record.id), ['w3', 'w2', 'w1']);

      final chartRecords = await weightRepository
          .watchRecordsForChart('r1')
          .first;
      expect(chartRecords.map((record) => record.id), ['w1', 'w2', 'w3']);

      expect(
        () => weightRepository.createRecord(
          _weight('bad', recordedAt: _utc(4), grams: 0),
        ),
        throwsA(isA<DomainValidationException>()),
      );

      await weightRepository.softDeleteRecord('w2');
      final visibleRecords = await weightRepository.watchRecords('r1').first;
      expect(visibleRecords.map((record) => record.id), ['w3', 'w1']);
    },
  );

  test('persists records after reopening the database file', () async {
    final previousWarningSetting =
        driftRuntimeOptions.dontWarnAboutMultipleDatabases;
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    addTearDown(() {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases =
          previousWarningSetting;
    });
    final directory = await Directory.systemTemp.createTemp(
      'raby-persistence-',
    );
    addTearDown(() => directory.delete(recursive: true));
    final dbFile = File(
      '${directory.path}${Platform.pathSeparator}raby-persistence.db',
    );

    final firstDatabase = AppDatabase.forTesting(NativeDatabase(dbFile));
    try {
      final firstRabbits = DriftRabbitRepository(
        firstDatabase,
        now: () => _fixedNow,
      );
      final firstDiaries = DriftDiaryRepository(
        firstDatabase,
        now: () => _fixedNow,
      );
      final firstTags = DriftTagRepository(firstDatabase, now: () => _fixedNow);
      final firstWeights = DriftWeightRepository(
        firstDatabase,
        now: () => _fixedNow,
      );

      await firstRabbits.createRabbit(_rabbit('r1'));
      await firstTags.ensureSystemTagsSeeded();
      final customTag = await firstTags.createCustomTag(
        rabbitId: 'r1',
        name: '晒窗台',
      );
      await firstDiaries.createDiary(
        diary: _diary('d-persist', recordedAt: _utc(3), content: '重启后还在'),
        media: [
          _media(
            'm-persist',
            diaryId: 'd-persist',
            relativePath: 'media/diaries/d-persist/photo-1.jpg',
            sortOrder: 0,
          ),
        ],
        tagIds: [customTag.id],
      );
      await firstWeights.createRecord(
        _weight('w-persist', recordedAt: _utc(3), grams: 1320),
      );
    } finally {
      await firstDatabase.close();
    }

    final reopenedDatabase = AppDatabase.forTesting(NativeDatabase(dbFile));
    try {
      final reopenedRabbits = DriftRabbitRepository(
        reopenedDatabase,
        now: () => _fixedNow,
      );
      final reopenedDiaries = DriftDiaryRepository(
        reopenedDatabase,
        now: () => _fixedNow,
      );
      final reopenedWeights = DriftWeightRepository(
        reopenedDatabase,
        now: () => _fixedNow,
      );

      final rabbit = await reopenedRabbits.getDefaultRabbit();
      expect(rabbit?.name, '米粒');

      final diary = await reopenedDiaries.getDiaryEntry('d-persist');
      expect(diary?.diary.content, '重启后还在');
      expect(diary?.media.single.relativePath, contains('photo-1.jpg'));
      expect(diary?.tags.map((tag) => tag.name), contains('晒窗台'));

      final weights = await reopenedWeights.watchRecords('r1').first;
      expect(weights.single.weightGrams, 1320);
    } finally {
      await reopenedDatabase.close();
    }
  });

  test('uses the injected clock for repository-created timestamps', () async {
    final expectedMillis = dateTimeToMillis(_fixedNow);
    await rabbitRepository.createRabbit(_rabbit('r1'));

    await tagRepository.ensureSystemTagsSeeded();
    final customTag = await tagRepository.createCustomTag(
      rabbitId: 'r1',
      name: '换毛期',
    );
    expect(customTag.createdAt, _fixedNow);
    expect(
      await _singleInt(database, 'SELECT created_at FROM tags WHERE id = ?', [
        customTag.id,
      ]),
      expectedMillis,
    );

    await diaryRepository.createDiary(
      diary: _diary('d-clock', recordedAt: _utc(2), content: '固定时间测试'),
      media: const [],
      tagIds: [customTag.id],
    );
    await diaryRepository.softDeleteDiary('d-clock');
    expect(
      await _singleInt(
        database,
        'SELECT deleted_at FROM diaries WHERE id = ?',
        ['d-clock'],
      ),
      expectedMillis,
    );

    await weightRepository.createRecord(
      _weight('w-clock', recordedAt: _utc(2), grams: 1300),
    );
    await weightRepository.softDeleteRecord('w-clock');
    expect(
      await _singleInt(
        database,
        'SELECT deleted_at FROM weight_records WHERE id = ?',
        ['w-clock'],
      ),
      expectedMillis,
    );

    await tagRepository.softDeleteTag(customTag.id);
    expect(
      await _singleInt(database, 'SELECT deleted_at FROM tags WHERE id = ?', [
        customTag.id,
      ]),
      expectedMillis,
    );

    await rabbitRepository.softDeleteRabbit('r1');
    expect(
      await _singleInt(
        database,
        'SELECT deleted_at FROM rabbits WHERE id = ?',
        ['r1'],
      ),
      expectedMillis,
    );
  });
}

DateTime _utc(int dayOffset) => DateTime.utc(2026, 6, 9 + dayOffset, 8);
final _fixedNow = DateTime.utc(2026, 6, 30, 9);

Future<int?> _singleInt(
  AppDatabase database,
  String sql,
  List<Object?> variables,
) async {
  final row = await database
      .customSelect(
        sql,
        variables: variables
            .map((value) => Variable<Object>(value as Object))
            .toList(growable: false),
      )
      .getSingle();
  return row.data.values.single as int?;
}

Rabbit _rabbit(String id, {DateTime? createdAt}) {
  final timestamp = createdAt ?? _utc(0);
  return Rabbit(
    id: id,
    name: id == 'r1' ? '米粒' : '团子',
    sex: RabbitSex.unknown,
    birthDate: '2023-03-01',
    breed: '垂耳兔',
    furColor: '奶油白',
    initialWeightGrams: 1280,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

Diary _diary(
  String id, {
  required DateTime recordedAt,
  required String content,
}) {
  return Diary(
    id: id,
    rabbitId: 'r1',
    recordedAt: recordedAt,
    content: content,
    createdAt: recordedAt,
    updatedAt: recordedAt,
  );
}

DiaryMedia _media(
  String id, {
  required String diaryId,
  required String relativePath,
  required int sortOrder,
}) {
  final timestamp = _utc(3);
  return DiaryMedia(
    id: id,
    diaryId: diaryId,
    mediaType: MediaType.image,
    relativePath: relativePath,
    sortOrder: sortOrder,
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

WeightRecord _weight(
  String id, {
  required DateTime recordedAt,
  required int grams,
}) {
  return WeightRecord(
    id: id,
    rabbitId: 'r1',
    recordedAt: recordedAt,
    weightGrams: grams,
    createdAt: recordedAt,
    updatedAt: recordedAt,
  );
}
