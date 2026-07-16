import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/data/media/media_storage_service.dart';
import 'package:raby/app/providers/repository_providers.dart';
import 'package:raby/app/router/app_routes.dart';
import 'package:raby/app/theme/raby_theme.dart';
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
import 'package:raby/features/profile/presentation/profile_page.dart';
import 'package:raby/features/rabbits/presentation/rabbit_detail_page.dart';
import 'package:raby/features/rabbits/presentation/rabbit_onboarding_page.dart';
import 'package:raby/features/records/presentation/diary_detail_page.dart';
import 'package:raby/features/records/presentation/diary_edit_page.dart';
import 'package:raby/features/records/presentation/diary_search_page.dart';
import 'package:raby/features/records/presentation/photo_album_page.dart';
import 'package:raby/features/records/presentation/photo_viewer_page.dart';
import 'package:raby/features/records/presentation/records_page.dart';
import 'package:raby/features/settings/presentation/settings_page.dart';
import 'package:raby/features/weight/presentation/weight_edit_page.dart';
import 'package:raby/features/weight/presentation/weight_page.dart';
import 'package:raby/shared/navigation/raby_shell.dart';

const _pages = [
  'home',
  'home-empty',
  'search',
  'album',
  'photo-viewer',
  'weight',
  'weight-empty',
  'weight-edit',
  'diary-edit',
  'diary-detail',
  'profile',
  'settings',
  'onboarding',
  'rabbit-detail',
];

void main() {
  for (final page in _pages) {
    testWidgets('capture $page', (tester) async {
      await _capturePage(tester, page);
    });
  }
}

Future<void> _capturePage(WidgetTester tester, String page) async {
  await _loadScreenshotFonts();

  final width = _envInt('RABY_SCREENSHOT_WIDTH', 430);
  final height = _envInt('RABY_SCREENSHOT_HEIGHT', 932);
  final pixelRatio = _envDouble('RABY_SCREENSHOT_PIXEL_RATIO', 2);
  tester.view.physicalSize = Size(width.toDouble(), height.toDouble());
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final scenario = _ScreenshotScenario.forPage(page);
  final mediaStorage = _ScreenshotMediaStorageService();
  await mediaStorage.prepare(scenario);
  final screenshotKey = GlobalKey();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        rabbitRepositoryProvider.overrideWithValue(
          _ScreenshotRabbitRepository(scenario),
        ),
        diaryRepositoryProvider.overrideWithValue(
          _ScreenshotDiaryRepository(scenario),
        ),
        tagRepositoryProvider.overrideWithValue(_ScreenshotTagRepository()),
        weightRepositoryProvider.overrideWithValue(
          _ScreenshotWeightRepository(scenario),
        ),
        mediaStorageServiceProvider.overrideWithValue(mediaStorage),
        clockProvider.overrideWithValue(() => _now),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _screenshotTheme(),
        locale: const Locale('zh', 'CN'),
        supportedLocales: const [Locale('zh', 'CN'), Locale('en')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: RepaintBoundary(key: screenshotKey, child: _pageWidget(page)),
      ),
    ),
  );
  await tester.pump();
  await _precacheScenarioImages(tester, screenshotKey, mediaStorage);
  await tester.pump(const Duration(milliseconds: 700));
  await tester.runAsync(() async {
    final decodeDelay =
        page == 'photo-viewer' ||
            scenario.diaries.any((entry) => entry.media.isNotEmpty)
        ? 1800
        : 350;
    await Future<void>.delayed(Duration(milliseconds: decodeDelay));
  });
  await tester.pump();
  if (page == 'photo-viewer') {
    for (var i = 0; i < 20; i += 1) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  final boundary =
      screenshotKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  final image = await boundary.toImage(pixelRatio: pixelRatio);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final file = File(_outputPath(page));
  file.parent.createSync(recursive: true);
  file.writeAsBytesSync(bytes!.buffer.asUint8List());

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();
}

Future<void> _precacheScenarioImages(
  WidgetTester tester,
  GlobalKey screenshotKey,
  _ScreenshotMediaStorageService mediaStorage,
) async {
  final context = screenshotKey.currentContext;
  if (context == null) {
    return;
  }
  for (final file in mediaStorage.preparedFiles) {
    if (!file.existsSync()) {
      continue;
    }
    await tester.runAsync(() async {
      await precacheImage(
        FileImage(file),
        context,
      ).timeout(const Duration(seconds: 2), onTimeout: () {});
    });
  }
  final avatarPath = mediaStorage.scenarioAvatarPath;
  if (avatarPath != null) {
    final avatarFile = await mediaStorage.resolve(avatarPath);
    if (avatarFile.existsSync()) {
      await tester.runAsync(() async {
        await precacheImage(
          FileImage(avatarFile),
          context,
        ).timeout(const Duration(seconds: 2), onTimeout: () {});
      });
    }
  }
  await tester.pump();
}

Widget _pageWidget(String page) {
  return switch (page) {
    'home' || 'home-empty' => const RabyShell(
      currentPath: AppRoutes.records,
      child: RecordsPage(),
    ),
    'search' => const DiarySearchPage(),
    'album' => const PhotoAlbumPage(),
    'photo-viewer' => PhotoViewerPage(
      args: PhotoViewerArgs(
        media: _sampleDiariesWithMedia.single.media,
        initialIndex: 0,
        returnPath: AppRoutes.records,
      ),
    ),
    'weight' || 'weight-empty' => const RabyShell(
      currentPath: AppRoutes.weight,
      child: WeightPage(),
    ),
    'weight-edit' => const WeightEditPage(),
    'diary-edit' => const DiaryEditPage(),
    'diary-detail' => const DiaryDetailPage(diaryId: 'd1'),
    'profile' => const RabyShell(
      currentPath: AppRoutes.me,
      child: ProfilePage(),
    ),
    'settings' => const SettingsPage(),
    'onboarding' => const RabbitOnboardingPage(),
    'rabbit-detail' => const RabbitDetailPage(),
    _ => throw ArgumentError('Unsupported screenshot page: $page'),
  };
}

String _outputPath(String page) {
  final configured = Platform.environment['RABY_SCREENSHOT_OUTPUT'];
  if (configured != null && configured.trim().isNotEmpty) {
    return configured;
  }
  return 'docs/prototypes/screenshots/raby-$page.png';
}

ThemeData _screenshotTheme() {
  final theme = RabyTheme.light;
  final buttonText = WidgetStateProperty.all(
    const TextStyle(
      fontFamily: rabyTextFontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
    ),
  );
  return theme.copyWith(
    textTheme: theme.textTheme.apply(fontFamily: rabyTextFontFamily),
    primaryTextTheme: theme.primaryTextTheme.apply(
      fontFamily: rabyTextFontFamily,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: theme.filledButtonTheme.style?.copyWith(textStyle: buttonText),
    ),
    textButtonTheme: TextButtonThemeData(
      style:
          theme.textButtonTheme.style?.copyWith(textStyle: buttonText) ??
          TextButton.styleFrom(textStyle: buttonText.resolve({})),
    ),
  );
}

Future<void> _loadScreenshotFonts() async {
  await _loadFontAsset('RabyChillRoundF', [
    'assets/fonts/chill-round/ChillRoundF.ttf',
  ]);
  await _loadFontAsset('RabyChillRoundM', [
    'assets/fonts/chill-round/ChillRoundM.ttf',
  ]);
  await _loadPackageFont(
    family: 'packages/lucide_flutter/LucideIcons',
    packageName: 'lucide_flutter',
    assetPath: 'assets/lucide.ttf',
  );
  await _loadFontIfExists('Microsoft YaHei', [
    'C:/Windows/Fonts/msyh.ttc',
    'C:/Windows/Fonts/simhei.ttf',
    'C:/Windows/Fonts/Deng.ttf',
  ]);
  await _loadFontIfExists('MaterialIcons', [
    'D:/work/toolchains/flutter/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  ]);
}

Future<void> _loadPackageFont({
  required String family,
  required String packageName,
  required String assetPath,
}) async {
  final configFile = File('.dart_tool/package_config.json');
  if (!configFile.existsSync()) {
    return;
  }
  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, Object?>;
  final packages = config['packages'] as List<Object?>? ?? const [];
  for (final rawPackage in packages) {
    final package = rawPackage as Map<String, Object?>;
    if (package['name'] != packageName) {
      continue;
    }
    final rootUriValue = package['rootUri'] as String?;
    if (rootUriValue == null) {
      return;
    }
    final resolvedRootUri = configFile.parent.uri.resolve(rootUriValue);
    final rootUri = resolvedRootUri.path.endsWith('/')
        ? resolvedRootUri
        : resolvedRootUri.replace(path: '${resolvedRootUri.path}/');
    final fontFile = File.fromUri(rootUri.resolve(assetPath));
    await _loadFontAsset(family, [fontFile.path]);
    return;
  }
}

Future<void> _loadFontAsset(String family, List<String> paths) async {
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    final fontBytes = file.readAsBytesSync();
    final byteData = ByteData.view(Uint8List.fromList(fontBytes).buffer);
    final loader = FontLoader(family)..addFont(Future.value(byteData));
    await loader.load();
    return;
  }
}

Future<void> _loadFontIfExists(String family, List<String> paths) async {
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) {
      continue;
    }
    final fontBytes = file.readAsBytesSync();
    final byteData = ByteData.view(Uint8List.fromList(fontBytes).buffer);
    final loader = FontLoader(family)..addFont(Future.value(byteData));
    await loader.load();
    return;
  }
}

int _envInt(String name, int fallback) {
  return int.tryParse(Platform.environment[name] ?? '') ?? fallback;
}

double _envDouble(String name, double fallback) {
  return double.tryParse(Platform.environment[name] ?? '') ?? fallback;
}

final _now = DateTime.utc(2026, 6, 10, 8);

class _ScreenshotScenario {
  const _ScreenshotScenario({
    required this.rabbit,
    required this.diaries,
    required this.weights,
  });

  factory _ScreenshotScenario.forPage(String page) {
    final emptyWeights =
        page == 'home-empty' || page == 'weight-empty' || page == 'weight-edit';
    final emptyDiaries = page == 'home-empty';
    return _ScreenshotScenario(
      rabbit: _rabbit,
      diaries: emptyDiaries
          ? const []
          : page == 'album' || page == 'photo-viewer'
          ? _sampleDiariesWithMedia
          : _sampleDiaries,
      weights: emptyWeights ? const [] : _sampleWeights,
    );
  }

  final Rabbit rabbit;
  final List<DiaryEntry> diaries;
  final List<WeightRecord> weights;
}

final _rabbit = Rabbit(
  id: 'rabbit-1',
  name: '糯米',
  sex: RabbitSex.unknown,
  birthDate: '2023-03-01',
  breed: '垂耳兔',
  furColor: '奶油白',
  initialWeightGrams: 1820,
  avatarPath: 'media/rabbits/rabbit-1/avatar/photo-0.png',
  createdAt: DateTime.utc(2026, 6, 10, 8),
  updatedAt: DateTime.utc(2026, 6, 10, 8),
);

final _sampleWeights = [
  WeightRecord(
    id: 'w7',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 6, 10, 12),
    weightGrams: 1820,
    createdAt: _now,
    updatedAt: _now,
  ),
  WeightRecord(
    id: 'w6',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 6, 7, 12),
    weightGrams: 1798,
    createdAt: _now,
    updatedAt: _now,
  ),
  WeightRecord(
    id: 'w5',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 6, 6, 12),
    weightGrams: 1788,
    createdAt: _now,
    updatedAt: _now,
  ),
  WeightRecord(
    id: 'w4',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 6, 4, 12),
    weightGrams: 1772,
    createdAt: _now,
    updatedAt: _now,
  ),
  WeightRecord(
    id: 'w3',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 6, 2, 12),
    weightGrams: 1760,
    createdAt: _now,
    updatedAt: _now,
  ),
  WeightRecord(
    id: 'w2',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 5, 30, 12),
    weightGrams: 1748,
    createdAt: _now,
    updatedAt: _now,
  ),
  WeightRecord(
    id: 'w1',
    rabbitId: _rabbit.id,
    recordedAt: DateTime.utc(2026, 5, 27, 12),
    weightGrams: 1742,
    createdAt: _now,
    updatedAt: _now,
  ),
];

final _sampleDiaries = [
  DiaryEntry(
    diary: Diary(
      id: 'd1',
      rabbitId: _rabbit.id,
      recordedAt: DateTime.utc(2026, 6, 10, 12),
      content: '今天精神很好,主动过来互动,吃草也很认真。',
      createdAt: _now,
      updatedAt: _now,
    ),
    media: [_diaryMedia('d1', 0)],
    tags: [_tag('system-daily', '日常', 0)],
  ),
  DiaryEntry(
    diary: Diary(
      id: 'd2',
      rabbitId: _rabbit.id,
      recordedAt: DateTime.utc(2026, 6, 9, 12),
      content: '牧草吃得很香,胃口棒棒哒。',
      createdAt: _now,
      updatedAt: _now,
    ),
    media: [_diaryMedia('d2', 1)],
    tags: [_tag('system-hay', '饮食', 2)],
  ),
  DiaryEntry(
    diary: Diary(
      id: 'd3',
      rabbitId: _rabbit.id,
      recordedAt: DateTime.utc(2026, 6, 8, 12),
      content: '今天玩了隧道球,跑来跑去好活泼。',
      createdAt: _now,
      updatedAt: _now,
    ),
    media: [_diaryMedia('d3', 2)],
    tags: [_tag('system-daily', '心情', 0)],
  ),
];

final _sampleDiariesWithMedia = [
  DiaryEntry(
    diary: Diary(
      id: 'd-photo',
      rabbitId: _rabbit.id,
      recordedAt: DateTime.utc(2026, 6, 10, 12),
      content: '今天拍了一组生活照片。',
      createdAt: _now,
      updatedAt: _now,
    ),
    media: [
      for (var i = 0; i < 5; i += 1)
        DiaryMedia(
          id: 'm$i',
          diaryId: 'd-photo',
          mediaType: MediaType.image,
          relativePath: 'media/diaries/d-photo/photo-$i.png',
          sortOrder: i,
          createdAt: _now,
          updatedAt: _now,
        ),
    ],
    tags: [_tag('system-daily', '日常', 0)],
  ),
];

Tag _tag(String id, String name, int sortOrder) {
  return Tag(
    id: id,
    name: name,
    tagKind: TagKind.normal,
    isSystem: true,
    colorToken: 'primary',
    sortOrder: sortOrder,
    createdAt: _now,
    updatedAt: _now,
  );
}

DiaryMedia _diaryMedia(String diaryId, int sortOrder) {
  return DiaryMedia(
    id: 'm-$diaryId-$sortOrder',
    diaryId: diaryId,
    mediaType: MediaType.image,
    relativePath: 'media/diaries/$diaryId/photo-$sortOrder.png',
    sortOrder: sortOrder,
    createdAt: _now,
    updatedAt: _now,
  );
}

class _ScreenshotRabbitRepository implements RabbitRepository {
  const _ScreenshotRabbitRepository(this._scenario);

  final _ScreenshotScenario _scenario;

  @override
  Stream<List<Rabbit>> watchActiveRabbits() async* {
    yield [_scenario.rabbit];
  }

  @override
  Stream<Rabbit?> watchDefaultRabbit() async* {
    yield _scenario.rabbit;
  }

  @override
  Future<Rabbit?> getDefaultRabbit() async => _scenario.rabbit;

  @override
  Future<void> createRabbit(Rabbit rabbit) async {}

  @override
  Future<void> updateRabbit(Rabbit rabbit) async {}

  @override
  Future<void> softDeleteRabbit(String id) async {}
}

class _ScreenshotDiaryRepository implements DiaryRepository {
  const _ScreenshotDiaryRepository(this._scenario);

  final _ScreenshotScenario _scenario;

  @override
  Stream<List<DiaryEntry>> watchTimeline(String rabbitId) async* {
    yield _scenario.diaries;
  }

  @override
  Future<DiaryEntry?> getDiaryEntry(String id) async {
    for (final entry in _scenario.diaries) {
      if (entry.diary.id == id) {
        return entry;
      }
    }
    return null;
  }

  @override
  Future<void> createDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) async {}

  @override
  Future<void> updateDiary({
    required Diary diary,
    required List<DiaryMedia> media,
    required List<String> tagIds,
  }) async {}

  @override
  Future<void> softDeleteDiary(String id) async {}
}

class _ScreenshotWeightRepository implements WeightRepository {
  const _ScreenshotWeightRepository(this._scenario);

  final _ScreenshotScenario _scenario;

  @override
  Stream<List<WeightRecord>> watchRecords(String rabbitId) async* {
    yield _scenario.weights;
  }

  @override
  Stream<List<WeightRecord>> watchRecordsForChart(String rabbitId) async* {
    yield _scenario.weights.reversed.toList(growable: false);
  }

  @override
  Future<void> createRecord(WeightRecord record) async {}

  @override
  Future<void> updateRecord(WeightRecord record) async {}

  @override
  Future<void> softDeleteRecord(String id) async {}
}

class _ScreenshotTagRepository implements TagRepository {
  _ScreenshotTagRepository()
    : _tags = [
        _tag('system-daily', '日常', 0),
        _tag('system-sun', '晒太阳', 1),
        _tag('system-hay', '吃草', 2),
        _tag('system-nails', '剪指甲', 3),
        _tag('system-vet', '看兽医', 4),
      ];

  final List<Tag> _tags;

  @override
  Future<void> ensureSystemTagsSeeded() async {}

  @override
  Future<List<Tag>> getAvailableTags(String rabbitId) async => _tags;

  @override
  Stream<List<Tag>> watchAvailableTags(String rabbitId) async* {
    yield _tags;
  }

  @override
  Future<Tag> createCustomTag({
    required String rabbitId,
    required String name,
    TagKind tagKind = TagKind.normal,
  }) async {
    final tag = Tag(
      id: 'custom-${_tags.length + 1}',
      rabbitId: rabbitId,
      name: name,
      tagKind: tagKind,
      isSystem: false,
      sortOrder: _tags.length,
      createdAt: _now,
      updatedAt: _now,
    );
    _tags.add(tag);
    return tag;
  }

  @override
  Future<void> softDeleteTag(String id) async {
    _tags.removeWhere((tag) => tag.id == id);
  }
}

class _ScreenshotMediaStorageService extends MediaStorageService {
  final _files = <String, File>{};
  String? _scenarioAvatarPath;

  Iterable<File> get preparedFiles => _files.values;
  String? get scenarioAvatarPath => _scenarioAvatarPath;

  Future<void> prepare(_ScreenshotScenario scenario) {
    _scenarioAvatarPath = scenario.rabbit.avatarPath;
    final avatarPath = scenario.rabbit.avatarPath;
    if (avatarPath != null && avatarPath.isNotEmpty) {
      _files[avatarPath] = _assetFileFor(avatarPath);
    }
    for (final entry in scenario.diaries) {
      for (final media in entry.media) {
        _files[media.relativePath] = _assetFileFor(media.relativePath);
      }
    }
    return SynchronousFuture(null);
  }

  @override
  Future<File> resolve(String relativePath) {
    return SynchronousFuture(
      _files[relativePath] ?? _assetFileFor(relativePath),
    );
  }

  File _assetFileFor(String relativePath) {
    final match = RegExp(r'photo-(\d+)').firstMatch(relativePath);
    final index = match == null
        ? relativePath.codeUnits.fold<int>(0, (sum, value) => sum + value) % 5
        : int.parse(match.group(1)!) % 5;
    final homeTimelineAsset = _homeTimelineAssetFile(index);
    if (homeTimelineAsset.existsSync()) {
      return homeTimelineAsset;
    }
    return File(
      '${Directory.current.path}${Platform.pathSeparator}tooling'
      '${Platform.pathSeparator}screenshot_harness'
      '${Platform.pathSeparator}assets'
      '${Platform.pathSeparator}sample_photo_$index.png',
    );
  }

  File _homeTimelineAssetFile(int index) {
    final assetIndex = index % 3 + 1;
    return File(
      '${Directory.current.path}${Platform.pathSeparator}assets'
      '${Platform.pathSeparator}images'
      '${Platform.pathSeparator}rabbits'
      '${Platform.pathSeparator}home'
      '${Platform.pathSeparator}rabbit_timeline_0$assetIndex.png',
    );
  }
}
