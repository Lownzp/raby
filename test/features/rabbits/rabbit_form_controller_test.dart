import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:raby/app/providers/repository_providers.dart';
import 'package:raby/data/media/media_storage_service.dart';
import 'package:raby/domain/models/rabbit.dart';
import 'package:raby/domain/models/raby_enums.dart';
import 'package:raby/domain/repositories/rabbit_repository.dart';
import 'package:raby/features/rabbits/application/rabbit_form_controller.dart';

void main() {
  test('creates rabbit and stores copied avatar relative path', () async {
    final tempDir = await Directory.systemTemp.createTemp('raby-avatar-test-');
    addTearDown(() => tempDir.delete(recursive: true));
    final source = File('${tempDir.path}${Platform.pathSeparator}avatar.png');
    await source.writeAsBytes([1, 2, 3]);

    final rabbitRepository = _FakeRabbitRepository();
    final mediaStorage = _FakeMediaStorageService();
    final container = _container(
      rabbitRepository: rabbitRepository,
      mediaStorageService: mediaStorage,
    );
    addTearDown(container.dispose);

    await container
        .read(rabbitFormControllerProvider)
        .create(
          RabbitFormInput(
            name: '米粒',
            sex: RabbitSex.unknown,
            birthDate: '2023-03-01',
            adoptedDate: '',
            breed: '垂耳兔',
            furColor: '奶油白',
            initialWeightGrams: 1820,
            avatarLocalPath: source.path,
          ),
        );

    final created = rabbitRepository.created.single;
    expect(created.avatarPath, isNotNull);
    expect(created.avatarPath, startsWith('media/rabbits/'));
    expect(created.avatarPath, endsWith('.png'));
    expect(created.initialWeightGrams, 1820);
    expect(mediaStorage.copied.single.sourcePath, source.path);
    expect(mediaStorage.copied.single.relativePath, created.avatarPath);
  });
}

ProviderContainer _container({
  required _FakeRabbitRepository rabbitRepository,
  required MediaStorageService mediaStorageService,
}) {
  return ProviderContainer(
    overrides: [
      rabbitRepositoryProvider.overrideWithValue(rabbitRepository),
      mediaStorageServiceProvider.overrideWithValue(mediaStorageService),
      clockProvider.overrideWithValue(() => _now),
    ],
  );
}

final _now = DateTime.utc(2026, 6, 10, 8);

class _CopiedMedia {
  const _CopiedMedia({required this.sourcePath, required this.relativePath});

  final String sourcePath;
  final String relativePath;
}

class _FakeMediaStorageService extends MediaStorageService {
  final List<_CopiedMedia> copied = [];

  @override
  Future<String> rabbitAvatarRelativePath({
    required String rabbitId,
    required String mediaId,
    String extension = 'jpg',
  }) async {
    return 'media/rabbits/$rabbitId/avatar/$mediaId.$extension';
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
}

class _FakeRabbitRepository implements RabbitRepository {
  final List<Rabbit> created = [];

  @override
  Stream<List<Rabbit>> watchActiveRabbits() {
    return const Stream.empty();
  }

  @override
  Stream<Rabbit?> watchDefaultRabbit() {
    return const Stream.empty();
  }

  @override
  Future<Rabbit?> getDefaultRabbit() async {
    return null;
  }

  @override
  Future<void> createRabbit(Rabbit rabbit) async {
    created.add(rabbit);
  }

  @override
  Future<void> updateRabbit(Rabbit rabbit) async {}

  @override
  Future<void> softDeleteRabbit(String id) async {}
}
