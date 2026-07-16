import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/app/providers/repository_providers.dart';
import 'package:raby/app/raby_app.dart';
import 'package:raby/data/media/media_storage_service.dart';
import 'package:raby/domain/domain_validation_exception.dart';
import 'package:raby/domain/models/diary.dart';
import 'package:raby/domain/models/diary_entry.dart';
import 'package:raby/domain/models/diary_media.dart';
import 'package:raby/domain/models/rabbit.dart';
import 'package:raby/domain/models/raby_enums.dart';
import 'package:raby/domain/models/tag.dart';
import 'package:raby/domain/models/weight_record.dart';
import 'package:raby/domain/repositories/diary_repository.dart';
import 'package:raby/domain/repositories/rabbit_repository.dart';
import 'package:raby/domain/repositories/tag_repository.dart';
import 'package:raby/domain/repositories/weight_repository.dart';

void main() {
  testWidgets('starts onboarding when no rabbit exists', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    expect(find.text('创建宠物档案'), findsOneWidget);
    expect(find.text('完成建档'), findsOneWidget);
  });

  testWidgets('records top add opens onboarding when no rabbit exists', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, initialLocation: '/records'),
    );
    await tester.pumpAndSettle();

    expect(find.text('请先建立兔兔档案'), findsOneWidget);

    await tester.tap(find.byTooltip('建立兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
    expect(find.text('写日记'), findsNothing);
  });

  testWidgets('records empty quick actions open onboarding', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, initialLocation: '/records'),
    );
    await tester.pumpAndSettle();

    expect(find.text('先建档'), findsOneWidget);
    expect(find.text('建档后记录'), findsOneWidget);

    await tester.tap(find.text('先建档'));
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
  });

  testWidgets('weight top add opens onboarding when no rabbit exists', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, initialLocation: '/weight'),
    );
    await tester.pumpAndSettle();

    expect(find.text('请先建立兔兔档案'), findsOneWidget);

    await tester.tap(find.byTooltip('建立兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
    expect(find.text('记录体重'), findsNothing);
  });

  testWidgets('profile empty state does not show a fake rabbit name', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository, initialLocation: '/me'));
    await tester.pumpAndSettle();

    expect(find.text('还没有兔兔档案'), findsOneWidget);
    expect(find.text('建立档案'), findsOneWidget);
    expect(find.text('糯米'), findsNothing);
  });

  testWidgets('rabbit detail empty state opens onboarding from top action', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, initialLocation: '/me/rabbit'),
    );
    await tester.pumpAndSettle();

    expect(find.text('还没有兔兔档案'), findsOneWidget);
    expect(find.byTooltip('编辑档案'), findsNothing);

    await tester.tap(find.byTooltip('建立兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
  });

  testWidgets('rabbit edit empty state offers onboarding action', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, initialLocation: '/me/rabbit/edit'),
    );
    await tester.pumpAndSettle();

    expect(find.text('还没有兔兔档案'), findsOneWidget);
    expect(find.text('建立兔兔档案'), findsOneWidget);

    await tester.tap(find.text('建立兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
  });

  testWidgets('weight editor empty state disables date picker action', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, initialLocation: '/weight/new'),
    );
    await tester.pumpAndSettle();

    expect(find.text('请先建立兔兔档案'), findsOneWidget);
    expect(find.byTooltip('选择日期'), findsNothing);
    expect(find.byTooltip('请先建立兔兔档案'), findsOneWidget);

    await tester.tap(find.byTooltip('请先建立兔兔档案'));
    await tester.pumpAndSettle();

    expect(find.text('选择日期'), findsNothing);
  });

  testWidgets('diary detail does not show a fake rabbit name without profile', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    final tagRepository = _FakeTagRepository();
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'orphan-diary',
            rabbitId: 'missing-rabbit',
            recordedAt: _testNow,
            content: '这是一条保留下来的日记。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: const [],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
        initialLocation: '/records/orphan-diary',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('日记详情'), findsOneWidget);
    expect(find.text('兔兔日记'), findsOneWidget);
    expect(find.text('糯米'), findsNothing);
    expect(find.byTooltip('编辑'), findsNothing);
    expect(find.text('查看趋势'), findsNothing);
    expect(find.text('建立兔兔档案'), findsOneWidget);

    await tester.tap(find.text('建立兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
  });

  testWidgets('creates first rabbit and shows it on records page', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();
    expect(find.text('创建宠物档案'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), '米粒');
    await tester.enterText(find.byType(TextFormField).at(1), '2023-03-01');
    await tester.enterText(find.byType(TextFormField).at(3), '垂耳兔');
    await tester.enterText(find.byType(TextFormField).at(4), '奶油白');
    await tester.enterText(find.byType(TextFormField).at(5), '1820');
    await tester.tap(find.text('完成建档'));
    await _pumpRoute(tester);

    expect(find.text('首页'), findsWidgets);
    expect(find.text('米粒'), findsOneWidget);
    expect(find.text('一只 3 岁的奶油白垂耳兔'), findsOneWidget);
    expect(
      (await rabbitRepository.getDefaultRabbit())?.initialWeightGrams,
      1820,
    );
  });

  testWidgets('rejects an out-of-range initial rabbit weight', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), '米粒');
    await tester.enterText(find.byType(TextFormField).at(1), '2023-03-01');
    await tester.enterText(find.byType(TextFormField).at(3), '垂耳兔');
    await tester.enterText(find.byType(TextFormField).at(4), '奶油白');
    await tester.enterText(find.byType(TextFormField).at(5), '20001');
    await tester.tap(find.text('完成建档'));
    await tester.pumpAndSettle();

    expect(find.text('初始体重需要在 1-20000g 之间'), findsOneWidget);
    expect(await rabbitRepository.getDefaultRabbit(), isNull);
  });

  testWidgets('shows existing rabbit across records and profile tabs', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    expect(find.text('米粒'), findsOneWidget);
    expect(find.text('当前体重'), findsOneWidget);
    expect(find.text('记体重'), findsOneWidget);
    expect(find.text('写日记'), findsWidgets);

    await _tapBottomNav(tester, '体重');
    expect(find.text('暂无体重数据'), findsOneWidget);

    await _tapBottomNav(tester, '我的');
    expect(find.text('查看和编辑 米粒'), findsOneWidget);
  });

  testWidgets('profile shows the latest recorded weight', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(
      seed: [_rabbit(initialWeightGrams: 1280)],
    );
    final weightRepository = _FakeWeightRepository(
      seed: [
        _weight(id: 'profile-latest-weight', recordedAt: _testNow, grams: 1310),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, weightRepository: weightRepository),
    );
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '我的');

    expect(find.textContaining('当前体重 1310g'), findsOneWidget);
    expect(find.textContaining('初始体重 1280g'), findsNothing);
  });

  testWidgets('home quick actions stay single-line on narrow phones', (
    tester,
  ) async {
    _useNarrowPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    final weightLabel = tester.getSize(find.text('记体重').first);
    final diaryLabel = tester.getSize(find.text('写日记').first);

    expect(weightLabel.height, lessThan(28));
    expect(diaryLabel.height, lessThan(28));
    expect(find.text('记体重'), findsOneWidget);
    expect(find.text('写日记'), findsWidgets);
  });

  testWidgets('home rabbit sticker cycles through three poses', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    final switcher = find.byKey(const ValueKey('home-rabbit-sticker-switcher'));
    expect(find.byKey(const ValueKey('home-rabbit-sticker-0')), findsOneWidget);

    await tester.tap(switcher);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home-rabbit-sticker-1')), findsOneWidget);

    await tester.tap(switcher);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home-rabbit-sticker-2')), findsOneWidget);

    await tester.tap(switcher);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home-rabbit-sticker-0')), findsOneWidget);
  });

  testWidgets('opens settings and hides unavailable v0.1.0 entries', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '我的');

    await tester.tap(find.text('设置'));
    await _pumpRoute(tester);

    expect(find.text('设置'), findsOneWidget);
    expect(find.text('App 信息'), findsOneWidget);
    expect(find.text('关于 Raby'), findsOneWidget);
    expect(find.text('v0.1.0'), findsWidgets);
    expect(find.textContaining('备份'), findsNothing);
    expect(find.textContaining('导入'), findsNothing);
    expect(find.textContaining('导出'), findsNothing);
    expect(find.textContaining('通知'), findsNothing);

    await tester.tap(find.byTooltip('返回'));
    await _pumpRoute(tester);

    expect(find.text('查看和编辑 米粒'), findsOneWidget);
  });

  testWidgets('creates edits and deletes a weight record', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(
      seed: [_rabbit(initialWeightGrams: 1280)],
    );
    final weightRepository = _FakeWeightRepository();
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, weightRepository: weightRepository),
    );
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '体重');

    expect(find.text('还没有体重记录'), findsOneWidget);

    await tester.tap(find.text('记录第一次体重'));
    await _pumpRoute(tester);
    expect(find.text('记录体重'), findsOneWidget);
    expect(find.widgetWithText(TextField, '1280'), findsOneWidget);

    expect(find.byKey(const ValueKey('raby-tab-体重')), findsOneWidget);
    await tester.tap(find.text('保存记录'));
    await _pumpRoute(tester);

    expect(find.text('1280 g'), findsWidgets);
    expect(find.text('还没有体重记录'), findsNothing);

    await tester.tap(find.byTooltip('更多操作').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑'));
    await _pumpRoute(tester);

    await tester.enterText(find.byType(TextField).first, '1310');
    await tester.pump();
    await tester.tap(find.text('保存记录'));
    await _pumpRoute(tester);

    expect(find.text('1310 g'), findsWidgets);
    expect(find.text('1280 g'), findsNothing);

    await tester.tap(find.byTooltip('更多操作').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除').last);
    await _pumpRoute(tester);

    expect(find.text('还没有体重记录'), findsOneWidget);
    expect(find.text('1310 g'), findsNothing);
  });

  testWidgets('weight range selector filters trend chart', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final weightRepository = _FakeWeightRepository(
      seed: [
        _weight(
          id: 'weight-archive',
          recordedAt: DateTime.utc(2025, 1, 1, 12),
          grams: 1180,
        ),
        _weight(
          id: 'weight-old',
          recordedAt: DateTime.utc(2026, 3, 15, 12),
          grams: 1240,
        ),
        _weight(
          id: 'weight-month',
          recordedAt: DateTime.utc(2026, 5, 20, 12),
          grams: 1290,
        ),
        _weight(
          id: 'weight-latest',
          recordedAt: DateTime.utc(2026, 6, 9, 12),
          grams: 1310,
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, weightRepository: weightRepository),
    );
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '体重');

    expect(find.text('3次称重'), findsNothing);
    expect(find.text('2次称重'), findsOneWidget);

    await tester.tap(find.text('7天'));
    await tester.pumpAndSettle();

    expect(find.text('至少2条'), findsOneWidget);

    await tester.tap(find.text('90天'));
    await tester.pumpAndSettle();

    expect(find.text('3次称重'), findsOneWidget);

    await tester.tap(find.text('全部'));
    await tester.pumpAndSettle();

    expect(find.text('4次称重'), findsOneWidget);
  });

  testWidgets('weight chart renders ten records in the default range', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final weightRepository = _FakeWeightRepository(
      seed: List.generate(
        10,
        (index) => _weight(
          id: 'weight-$index',
          recordedAt: DateTime.utc(2026, 6, index + 1, 12),
          grams: 1250 + index * 8,
        ),
      ),
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(rabbitRepository, weightRepository: weightRepository),
    );
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '体重');

    expect(find.text('10次称重'), findsOneWidget);
    expect(find.text('共 10 条记录'), findsOneWidget);
    expect(find.text('最高'), findsOneWidget);
    expect(find.text('最低'), findsOneWidget);
    expect(find.text('平均'), findsOneWidget);
    expect(find.text('至少2条'), findsNothing);
  });

  testWidgets('opens rabbit detail and saves profile edits', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '我的');

    await tester.tap(find.text('兔兔档案'));
    await _pumpRoute(tester);
    expect(find.text('兔兔档案'), findsOneWidget);
    expect(find.textContaining('奶油白'), findsOneWidget);

    await tester.tap(find.byTooltip('编辑档案'));
    await _pumpRoute(tester);
    await tester.enterText(find.byType(TextFormField).at(4), '海盐灰');
    await tester.tap(find.text('保存修改'));
    await _pumpRoute(tester);

    expect(find.textContaining('海盐灰'), findsOneWidget);
  });

  testWidgets('deletes rabbit profile after confirmation', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '我的');
    await tester.tap(find.text('兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('删除档案'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, '删除'));
    await tester.pumpAndSettle();

    expect(find.text('删除 米粒 的档案?'), findsOneWidget);

    await tester.tap(find.text('删除').last);
    await _pumpRoute(tester);

    expect(find.text('创建宠物档案'), findsOneWidget);
    expect(await rabbitRepository.getDefaultRabbit(), isNull);
  });

  testWidgets('rabbit detail quick actions open record editors', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '我的');
    await tester.tap(find.text('兔兔档案'));
    await _pumpRoute(tester);

    expect(find.text('常用记录'), findsOneWidget);

    await tester.tap(find.widgetWithText(OutlinedButton, '记体重'));
    await _pumpRoute(tester);
    expect(find.text('记录体重'), findsOneWidget);

    await tester.tap(find.byTooltip('返回'));
    await _pumpRoute(tester);

    await _tapBottomNav(tester, '我的');
    await tester.tap(find.text('兔兔档案'));
    await _pumpRoute(tester);

    await tester.tap(find.widgetWithText(FilledButton, '写日记'));
    await _pumpRoute(tester);
    expect(find.text('写日记'), findsOneWidget);
  });

  testWidgets('diary draft survives a temporary weight entry visit', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('写第一条日记'));
    await _pumpRoute(tester);
    await tester.enterText(find.byType(TextField).first, '这段草稿不能丢');
    await tester.pump();

    await tester.ensureVisible(find.text('去记录'));
    await tester.tap(find.text('去记录'));
    await _pumpRoute(tester);
    expect(find.text('记录体重'), findsOneWidget);

    await tester.tap(find.byTooltip('返回'));
    await _pumpRoute(tester);

    expect(find.text('写日记'), findsOneWidget);
    expect(find.text('这段草稿不能丢'), findsOneWidget);
  });

  testWidgets('creates edits and deletes a diary from records timeline', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final diaryRepository = _FakeDiaryRepository(tagRepository: tagRepository);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('还没有生活记录'), findsOneWidget);

    await tester.tap(find.text('写第一条日记'));
    await _pumpRoute(tester);
    expect(find.text('写日记'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '今天吃草很认真');
    await tester.pump();
    await tester.tap(find.text('饮食'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilterChip, '日常'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilterChip, '里程碑'));
    await tester.pump();
    await tester.tap(find.text('保存日记'));
    await _pumpRoute(tester);

    expect(find.text('今天吃草很认真'), findsOneWidget);
    expect(find.text('吃草'), findsOneWidget);
    expect(find.text('日常'), findsOneWidget);
    expect(find.text('里程碑'), findsOneWidget);

    await tester.tap(find.byTooltip('更多操作').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('编辑'));
    await _pumpRoute(tester);

    await tester.enterText(find.byType(TextField).first, '更新: 今天主动来互动');
    await tester.pump();
    await tester.tap(find.text('保存日记'));
    await _pumpRoute(tester);

    expect(find.text('更新: 今天主动来互动'), findsOneWidget);
    expect(find.text('今天吃草很认真'), findsNothing);

    await tester.tap(find.byTooltip('更多操作').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除').last);
    await _pumpRoute(tester);

    expect(find.text('还没有生活记录'), findsOneWidget);
    expect(find.text('更新: 今天主动来互动'), findsNothing);
  });

  testWidgets('opens diary detail from timeline and enters edit flow', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'diary-1',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow,
            content: '今天主动来互动,吃草也很认真。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: const [],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('今天主动来互动,吃草也很认真。'), findsOneWidget);

    await tester.tap(find.text('今天主动来互动,吃草也很认真。'));
    await _pumpRoute(tester);

    expect(find.text('日记详情'), findsOneWidget);
    expect(find.text('当天还没有记录体重'), findsOneWidget);
    expect(find.byKey(const ValueKey('raby-tab-首页')), findsOneWidget);

    await tester.ensureVisible(find.widgetWithText(OutlinedButton, '编辑'));
    await tester.tap(find.widgetWithText(OutlinedButton, '编辑'));
    await _pumpRoute(tester);

    expect(find.text('编辑日记'), findsOneWidget);
    expect(find.text('今天主动来互动,吃草也很认真。'), findsOneWidget);
  });

  testWidgets('deletes a diary from detail page', (tester) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'diary-delete',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow,
            content: '今天晒太阳很舒服。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: const [],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('今天晒太阳很舒服。'));
    await _pumpRoute(tester);

    expect(find.text('日记详情'), findsOneWidget);

    await tester.tap(find.byTooltip('更多操作'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除').last);
    await _pumpRoute(tester);

    expect(find.text('还没有生活记录'), findsOneWidget);
    expect(find.text('今天晒太阳很舒服。'), findsNothing);
  });

  testWidgets('opens photo from diary detail and returns to detail', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final media = DiaryMedia(
      id: 'detail-media-1',
      diaryId: 'diary-detail-photo',
      mediaType: MediaType.image,
      relativePath: 'media/diaries/diary-detail-photo/photo.png',
      sortOrder: 0,
      createdAt: _testNow,
      updatedAt: _testNow,
    );
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'diary-detail-photo',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow,
            content: '今天拍了一张特写。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: [media],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
        mediaStorageService: _PendingMediaStorageService(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('今天拍了一张特写。'));
    await _pumpRoute(tester);

    expect(find.text('日记详情'), findsOneWidget);
    expect(find.byTooltip('查看照片 1'), findsOneWidget);

    await tester.tap(find.byTooltip('查看照片 1'));
    await _pumpRoute(tester);

    expect(find.text('1/1'), findsOneWidget);

    await tester.tap(find.byTooltip('返回详情'));
    await _pumpRoute(tester);

    expect(find.text('日记详情'), findsOneWidget);
    expect(find.text('今天拍了一张特写。'), findsOneWidget);
  });

  testWidgets('searches diary timeline and opens a matching result', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'diary-hay',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow,
            content: '今天吃草很认真。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: const [],
          tags: const [],
        ),
        DiaryEntry(
          diary: Diary(
            id: 'diary-play',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow.subtract(const Duration(days: 1)),
            content: '晚上玩隧道球很开心。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: const [],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('搜索日记'));
    await _pumpRoute(tester);

    expect(find.text('搜索日记'), findsOneWidget);
    expect(find.text('可搜索 2 条日记'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '吃草');
    await tester.pump();

    expect(find.text('找到 1 条'), findsOneWidget);
    expect(find.text('今天吃草很认真。'), findsOneWidget);
    expect(find.text('晚上玩隧道球很开心。'), findsNothing);

    await tester.tap(find.text('今天吃草很认真。'));
    await _pumpRoute(tester);

    expect(find.text('日记详情'), findsOneWidget);
    expect(find.text('今天吃草很认真。'), findsOneWidget);
  });

  testWidgets('opens photo album from profile and returns from viewer', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final media = DiaryMedia(
      id: 'album-media-1',
      diaryId: 'diary-photo',
      mediaType: MediaType.image,
      relativePath: 'media/diaries/diary-photo/photo.png',
      sortOrder: 0,
      createdAt: _testNow,
      updatedAt: _testNow,
    );
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'diary-photo',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow,
            content: '今天拍了一张照片。',
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: [media],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
        mediaStorageService: _PendingMediaStorageService(),
      ),
    );
    await tester.pumpAndSettle();

    await _tapBottomNav(tester, '我的');
    await tester.tap(find.text('照片相册'));
    await _pumpRoute(tester);

    expect(find.text('照片相册'), findsOneWidget);
    expect(find.text('1 张照片'), findsOneWidget);
    expect(find.byKey(const ValueKey('album-filter-all')), findsOneWidget);
    expect(find.byKey(const ValueKey('raby-tab-我的')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('album-filter-daily')));
    await tester.pumpAndSettle();
    expect(find.text('这个分类还没有照片'), findsOneWidget);

    await tester.tap(find.text('查看全部'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('查看照片 1 · 2026-06-09'), findsOneWidget);

    await tester.tap(find.byTooltip('查看照片 1 · 2026-06-09'));
    await _pumpRoute(tester);

    expect(find.text('1/1'), findsOneWidget);

    await tester.tap(find.byTooltip('返回相册'));
    await _pumpRoute(tester);

    expect(find.text('照片相册'), findsOneWidget);
  });

  testWidgets('diary editor back controls return to records page', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(_testApp(rabbitRepository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('写第一条日记'));
    await _pumpRoute(tester);
    expect(find.text('写日记'), findsOneWidget);

    await tester.tap(find.byTooltip('返回'));
    await _pumpRoute(tester);
    expect(find.text('还没有生活记录'), findsOneWidget);

    await tester.tap(find.text('写第一条日记'));
    await _pumpRoute(tester);
    expect(find.text('写日记'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await _pumpRoute(tester);
    expect(find.text('还没有生活记录'), findsOneWidget);
  });

  testWidgets('opens timeline photo viewer and returns to records page', (
    tester,
  ) async {
    _useTallPhoneSurface(tester);
    final rabbitRepository = _FakeRabbitRepository(seed: [_rabbit()]);
    final tagRepository = _FakeTagRepository();
    final media = DiaryMedia(
      id: 'media-1',
      diaryId: 'diary-photo',
      mediaType: MediaType.image,
      relativePath: 'media/diaries/diary-photo/photo.png',
      sortOrder: 0,
      createdAt: _testNow,
      updatedAt: _testNow,
    );
    final diaryRepository = _FakeDiaryRepository(
      tagRepository: tagRepository,
      seed: [
        DiaryEntry(
          diary: Diary(
            id: 'diary-photo',
            rabbitId: 'rabbit-1',
            recordedAt: _testNow,
            content: null,
            createdAt: _testNow,
            updatedAt: _testNow,
          ),
          media: [media],
          tags: const [],
        ),
      ],
    );
    addTearDown(rabbitRepository.dispose);

    await tester.pumpWidget(
      _testApp(
        rabbitRepository,
        tagRepository: tagRepository,
        diaryRepository: diaryRepository,
        mediaStorageService: _PendingMediaStorageService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip('查看照片 1'), findsOneWidget);

    await tester.tap(find.byTooltip('查看照片 1'));
    await _pumpRoute(tester);

    expect(find.text('1/1'), findsOneWidget);

    await tester.tap(find.byTooltip('返回记录页'));
    await _pumpRoute(tester);

    expect(find.byTooltip('查看照片 1'), findsOneWidget);
  });
}

Widget _testApp(
  _FakeRabbitRepository rabbitRepository, {
  _FakeTagRepository? tagRepository,
  _FakeDiaryRepository? diaryRepository,
  _FakeWeightRepository? weightRepository,
  MediaStorageService? mediaStorageService,
  String? initialLocation,
}) {
  final resolvedTagRepository = tagRepository ?? _FakeTagRepository();
  final resolvedDiaryRepository =
      diaryRepository ??
      _FakeDiaryRepository(tagRepository: resolvedTagRepository);
  final resolvedWeightRepository = weightRepository ?? _FakeWeightRepository();

  return ProviderScope(
    overrides: [
      rabbitRepositoryProvider.overrideWithValue(rabbitRepository),
      tagRepositoryProvider.overrideWithValue(resolvedTagRepository),
      diaryRepositoryProvider.overrideWithValue(resolvedDiaryRepository),
      weightRepositoryProvider.overrideWithValue(resolvedWeightRepository),
      if (mediaStorageService != null)
        mediaStorageServiceProvider.overrideWithValue(mediaStorageService),
      clockProvider.overrideWithValue(() => _testNow),
    ],
    child: RabyApp(initialLocation: initialLocation),
  );
}

void _useTallPhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(430, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void _useNarrowPhoneSurface(WidgetTester tester) {
  tester.view.physicalSize = const Size(360, 780);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _pumpRoute(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 120));
  await tester.pump(const Duration(milliseconds: 360));
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _tapBottomNav(WidgetTester tester, String label) async {
  await tester.tap(find.byKey(ValueKey('raby-tab-$label')));
  await _pumpRoute(tester);
}

Rabbit _rabbit({String id = 'rabbit-1', int? initialWeightGrams}) {
  return Rabbit(
    id: id,
    name: '米粒',
    sex: RabbitSex.unknown,
    birthDate: '2023-03-01',
    breed: '垂耳兔',
    furColor: '奶油白',
    initialWeightGrams: initialWeightGrams,
    createdAt: _testNow,
    updatedAt: _testNow,
  );
}

WeightRecord _weight({
  required String id,
  required DateTime recordedAt,
  required int grams,
  String rabbitId = 'rabbit-1',
}) {
  return WeightRecord(
    id: id,
    rabbitId: rabbitId,
    recordedAt: recordedAt,
    weightGrams: grams,
    createdAt: _testNow,
    updatedAt: _testNow,
  );
}

final _testNow = DateTime.utc(2026, 6, 9, 8);

class _FakeRabbitRepository implements RabbitRepository {
  _FakeRabbitRepository({List<Rabbit> seed = const []}) : _rabbits = [...seed];

  final List<Rabbit> _rabbits;
  final _changes = StreamController<List<Rabbit>>.broadcast(sync: true);

  @override
  Stream<List<Rabbit>> watchActiveRabbits() async* {
    yield List.unmodifiable(_rabbits);
    yield* _changes.stream;
  }

  @override
  Stream<Rabbit?> watchDefaultRabbit() async* {
    yield await getDefaultRabbit();
    yield* _changes.stream.map(
      (rabbits) => rabbits.isEmpty ? null : rabbits.first,
    );
  }

  @override
  Future<Rabbit?> getDefaultRabbit() async {
    return _rabbits.isEmpty ? null : _rabbits.first;
  }

  @override
  Future<void> createRabbit(Rabbit rabbit) async {
    _rabbits.add(rabbit);
    _emit();
  }

  @override
  Future<void> updateRabbit(Rabbit rabbit) async {
    final index = _rabbits.indexWhere((item) => item.id == rabbit.id);
    if (index == -1) {
      _rabbits.add(rabbit);
    } else {
      _rabbits[index] = rabbit;
    }
    _emit();
  }

  @override
  Future<void> softDeleteRabbit(String id) async {
    _rabbits.removeWhere((rabbit) => rabbit.id == id);
    _emit();
  }

  void _emit() {
    _changes.add(List.unmodifiable(_rabbits));
  }

  Future<void> dispose() {
    return _changes.close();
  }
}

class _FakeDiaryRepository implements DiaryRepository {
  _FakeDiaryRepository({
    required this.tagRepository,
    List<DiaryEntry> seed = const [],
  }) {
    for (final entry in seed) {
      _diaries[entry.diary.id] = entry.diary;
      _mediaByDiaryId[entry.diary.id] = List.unmodifiable(entry.media);
      _tagIdsByDiaryId[entry.diary.id] = List.unmodifiable(
        entry.tags.map((tag) => tag.id),
      );
    }
  }

  final _FakeTagRepository tagRepository;
  final Map<String, Diary> _diaries = {};
  final Map<String, List<DiaryMedia>> _mediaByDiaryId = {};
  final Map<String, List<String>> _tagIdsByDiaryId = {};
  final List<void Function()> _listeners = [];

  @override
  Stream<List<DiaryEntry>> watchTimeline(String rabbitId) {
    return Stream.multi((controller) {
      void emit() => controller.add(_timeline(rabbitId));
      _listeners.add(emit);
      emit();
      controller.onCancel = () => _listeners.remove(emit);
    });
  }

  @override
  Future<DiaryEntry?> getDiaryEntry(String id) async {
    final diary = _diaries[id];
    if (diary == null) {
      return null;
    }
    return _entryFor(diary);
  }

  @override
  Future<void> createDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) async {
    _validate(diary: diary, media: media);
    _diaries[diary.id] = diary;
    _mediaByDiaryId[diary.id] = List.unmodifiable(media);
    _tagIdsByDiaryId[diary.id] = _distinct(tagIds);
    _emit();
  }

  @override
  Future<void> updateDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) async {
    _validate(diary: diary, media: media);
    _diaries[diary.id] = diary;
    _mediaByDiaryId[diary.id] = List.unmodifiable(media);
    _tagIdsByDiaryId[diary.id] = _distinct(tagIds);
    _emit();
  }

  @override
  Future<void> softDeleteDiary(String id) async {
    _diaries.remove(id);
    _mediaByDiaryId.remove(id);
    _tagIdsByDiaryId.remove(id);
    _emit();
  }

  List<DiaryEntry> _timeline(String rabbitId) {
    final entries = _diaries.values
        .where((diary) => diary.rabbitId == rabbitId)
        .map(_entryFor)
        .toList();
    entries.sort((a, b) {
      final recordedCompare = b.diary.recordedAt.compareTo(a.diary.recordedAt);
      if (recordedCompare != 0) {
        return recordedCompare;
      }
      return b.diary.createdAt.compareTo(a.diary.createdAt);
    });
    return List.unmodifiable(entries);
  }

  DiaryEntry _entryFor(Diary diary) {
    final tagIds = _tagIdsByDiaryId[diary.id] ?? const <String>[];
    return DiaryEntry(
      diary: diary,
      media: List.unmodifiable(_mediaByDiaryId[diary.id] ?? const []),
      tags: List.unmodifiable(
        tagIds.map(tagRepository.lookup).whereType<Tag>(),
      ),
    );
  }

  void _validate({required Diary diary, required List<DiaryMedia> media}) {
    final hasContent = diary.content?.trim().isNotEmpty ?? false;
    if (!hasContent && media.isEmpty) {
      throw const DomainValidationException('日记正文和照片至少需要一个');
    }
    if (media.length > 9) {
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

  void _emit() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}

class _FakeWeightRepository implements WeightRepository {
  _FakeWeightRepository({List<WeightRecord> seed = const []})
    : _records = [...seed];

  final List<WeightRecord> _records;
  final List<void Function()> _listeners = [];

  @override
  Stream<List<WeightRecord>> watchRecords(String rabbitId) {
    return Stream.multi((controller) {
      void emit() => controller.add(_recordsFor(rabbitId, ascending: false));
      _listeners.add(emit);
      emit();
      controller.onCancel = () => _listeners.remove(emit);
    });
  }

  @override
  Stream<List<WeightRecord>> watchRecordsForChart(String rabbitId) {
    return Stream.multi((controller) {
      void emit() => controller.add(_recordsFor(rabbitId, ascending: true));
      _listeners.add(emit);
      emit();
      controller.onCancel = () => _listeners.remove(emit);
    });
  }

  @override
  Future<void> createRecord(WeightRecord record) async {
    _validate(record);
    _records.add(record);
    _emit();
  }

  @override
  Future<void> updateRecord(WeightRecord record) async {
    _validate(record);
    final index = _records.indexWhere((item) => item.id == record.id);
    if (index == -1) {
      _records.add(record);
    } else {
      _records[index] = record;
    }
    _emit();
  }

  @override
  Future<void> softDeleteRecord(String id) async {
    _records.removeWhere((record) => record.id == id);
    _emit();
  }

  List<WeightRecord> _recordsFor(String rabbitId, {required bool ascending}) {
    final visible = _records
        .where((record) => record.rabbitId == rabbitId)
        .toList();
    visible.sort((a, b) {
      final compare = a.recordedAt.compareTo(b.recordedAt);
      return ascending ? compare : -compare;
    });
    return List.unmodifiable(visible);
  }

  void _validate(WeightRecord record) {
    if (record.weightGrams <= 0 || record.weightGrams > 20000) {
      throw const DomainValidationException('体重需要在 1-20000g 之间');
    }
  }

  void _emit() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}

class _PendingMediaStorageService extends MediaStorageService {
  final _pending = Completer<File>();

  @override
  Future<File> resolve(String relativePath) async {
    return _pending.future;
  }
}

class _FakeTagRepository implements TagRepository {
  final List<Tag> _tags = [];
  final List<void Function()> _listeners = [];
  bool _seeded = false;

  @override
  Future<void> ensureSystemTagsSeeded() async {
    if (_seeded) {
      return;
    }
    _seeded = true;
    _tags.addAll(_systemTags());
    _emit();
  }

  @override
  Future<List<Tag>> getAvailableTags(String rabbitId) async {
    return _availableTags(rabbitId);
  }

  @override
  Stream<List<Tag>> watchAvailableTags(String rabbitId) {
    return Stream.multi((controller) {
      void emit() => controller.add(_availableTags(rabbitId));
      _listeners.add(emit);
      emit();
      controller.onCancel = () => _listeners.remove(emit);
    });
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
    final duplicated = _availableTags(rabbitId).any(
      (tag) =>
          !tag.isSystem &&
          tag.rabbitId == rabbitId &&
          tag.name.toLowerCase() == trimmedName.toLowerCase(),
    );
    if (duplicated) {
      throw const DomainValidationException('同一只兔子的标签名不能重复');
    }

    final now = DateTime.utc(2026, 6, 9, 8);
    final tag = Tag(
      id: 'tag-${_tags.length + 1}',
      rabbitId: rabbitId,
      name: trimmedName,
      tagKind: tagKind,
      isSystem: false,
      colorToken: tagKind == TagKind.milestone ? 'secondary' : 'primary',
      sortOrder: _tags.length,
      createdAt: now,
      updatedAt: now,
    );
    _tags.add(tag);
    _emit();
    return tag;
  }

  @override
  Future<void> softDeleteTag(String id) async {
    _tags.removeWhere((tag) => tag.id == id);
    _emit();
  }

  Tag? lookup(String id) {
    for (final tag in _tags) {
      if (tag.id == id) {
        return tag;
      }
    }
    return null;
  }

  List<Tag> _availableTags(String rabbitId) {
    final tags = _tags
        .where((tag) => tag.isSystem || tag.rabbitId == rabbitId)
        .toList();
    tags.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return List.unmodifiable(tags);
  }

  List<Tag> _systemTags() {
    final now = DateTime.utc(2026, 6, 9, 8);
    return [
      _tag(id: 'system-daily', name: '日常', sortOrder: 0, now: now),
      _tag(id: 'system-sun', name: '晒太阳', sortOrder: 1, now: now),
      _tag(id: 'system-hay', name: '吃草', sortOrder: 2, now: now),
      _tag(id: 'system-nails', name: '剪指甲', sortOrder: 3, now: now),
      _tag(id: 'system-vet', name: '看兽医', sortOrder: 4, now: now),
      _tag(
        id: 'system-milestone',
        name: '里程碑',
        tagKind: TagKind.milestone,
        sortOrder: 5,
        now: now,
      ),
    ];
  }

  Tag _tag({
    required String id,
    required String name,
    required int sortOrder,
    required DateTime now,
    TagKind tagKind = TagKind.normal,
  }) {
    return Tag(
      id: id,
      name: name,
      tagKind: tagKind,
      isSystem: true,
      colorToken: tagKind == TagKind.milestone ? 'secondary' : 'primary',
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
    );
  }

  void _emit() {
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}
